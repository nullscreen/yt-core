module Yt
  # Provides a base class for YouTube channels, videos, playlists and items.
  # This is an abstract class and should not be instantiated directly.
  class Resource
    # @param [Hash<Symbol, String>] data the options to initialize a resource.
    # @option data [String] :id The unique ID of a YouTube resource.
    def initialize(data = {})
      @data = data
      @selected_data_parts = []
    end

    # @return [String] the resource’s unique ID.
    def id
      @data[:id]
    end

    # @return [Hash] the resource’s data.
    attr_reader :data

    # @return [String] a representation of the resource instance.
    def inspect
      "#<#{self.class} @id=#{id}>"
    end

    # Specifies which parts of the resource to fetch when hitting the data API.
    # @param [Array<Symbol>] parts The parts to fetch.
    # @return [Yt::Resource] itself.
    def select(*parts)
      @selected_data_parts = parts
      self
    end

    # @return [Yt::Relation<Yt::Video>] the videos matching the conditions.
    def self.where(conditions = {})
      @where ||= Relation.new(self) do |options|
        slicing_conditions_every(50) do |slice_options|
          get resources_path, where_params(slice_options)
        end
      end
      @where.where conditions
    end

  private

    def camelize(part)
      part.to_s.gsub(/(?:_|(\/))([a-z\d]*)/i) { "#{$1}#{$2.capitalize}" }
    end

    def self.has_attribute(name, options = {}, &block)
      define_method name do
        keys = Array(options[:in]) + [name]
        part = keys.shift
        value = @data[part] || get_part(part)
        keys.each{|key| value = value[camelize key]}
        if value.nil? && options[:default]
          value = options[:default]
        end
        value = type_cast value, options[:type]
        block_given? ? instance_exec(value, &block) : value
      end
    end

    def get_part(required_part)
      resources = Relation.new(self.class, part_params) do |options|
        get resources_path, resource_params(options)
      end

      parts = (@selected_data_parts + [required_part]).uniq
      if (resource = resources.select(*parts).first)
        parts.each{|part| @data[part] = resource.data[part]}
        @data[required_part]
      else
        raise NoItemsError
      end
    end

    def part_params
      {ids: [id]}
    end

    def type_cast(value, type)
      case [type]
      when [Time]
        Time.parse value
      when [Integer]
        value.to_i
      when [Comment]
        Comment.new id: value['id'], snippet: value['snippet']
      else
        value
      end
    end
  end
end