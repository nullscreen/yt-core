module Yt
  # Provides a base class for multiple YouTube resources (channel, video, ...).
  # This is an abstract class and should not be instantiated directly.
  class Resource
    # @param [Hash<Symbol, String>] data the options to initialize a resource.
    # @option data [String] :id The unique ID of a YouTube resource.
    def initialize(data = {})
      @data = data
    end

    # @return [String] the resource’s unique ID.
    def id
      @data[:id]
    end

    # @return [String] a representation of the resource instance.
    def inspect
      "#<#{self.class} @id=#{id}>"
    end

  private

    def self.fetch(path, params)
      params = params.merge(max_results: 50, key: Yt.configuration.api_key)
      HTTPRequest.new(path: path, params: params).run
    end

    def fetch(path, params)
      self.class.fetch path, params
    end

    def camelize(part)
      part.to_s.gsub(/(?:_|(\/))([a-z\d]*)/i) { "#{$1}#{$2.capitalize}" }
    end

    def self.has_attribute(name, options = {}, &block)
      define_method name do
        keys = Array(options[:in]) + [name]
        part = keys.shift
        value = @data[part] || fetch_part(part)
        keys.each{|key| value = value[camelize key]}
        value = type_cast value, options[:type]
        block_given? ? instance_exec(value, &block) : value
      end
    end

    def fetch_part(part)
      parts = @selected_data_parts || [part]
      resource = fetch resources_path, id: id, part: parts.join(',')

      if (items = resource.body['items']).any?
        parts.each{|part| @data[part] = items.first[camelize part]}
        @data[part]
      else
        raise Errors::NoItems
      end
    end

    # Expands the resultset into a collection of videos by fetching missing
    # parts, eventually with an additional HTTP request.
    def videos_for(items, key, options)
      items.body['items'].map{|item| item['id'] = item[camelize key]['videoId']}

      if options[:parts] == %i(id)
        items
      else
        options[:ids] = items.body['items'].map{|item| item['id']}
        fetch('/youtube/v3/videos', videos_params(options)).tap do |response|
          response.body['nextPageToken'] = items.body['nextPageToken']
        end
      end
    end

    def videos_params(options)
      {}.tap do |params|
        params[:part] = options[:parts].join ','
        params[:id] = options[:ids].join ','
      end
    end

    def resources_path
      self.class.name.split('::').last.gsub /^(\w{1})(.*)/ do
        "/youtube/v3/#{$1.downcase}#{$2}s"
      end
    end

    def type_cast(value, type)
      case [type]
      when [Time]
        Time.parse value
      when [Integer]
        value.to_i
      else
        value
      end
    end
  end
end