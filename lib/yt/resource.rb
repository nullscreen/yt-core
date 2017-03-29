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

    def fetch(path, params)
      HTTPRequest.new(path: path, params: params).run
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
      request = HTTPRequest.new({
        path: resources_path,
        params: {key: Yt.configuration.api_key, id: id, part: parts.join(',')}
      })

      if (items = request.run.body['items']).any?
        parts.each{|part| @data[part] = items.first[camelize part]}
        @data[part]
      else
        raise Errors::NoItems
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