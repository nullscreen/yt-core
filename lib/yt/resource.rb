module Yt
  # Provides a base class for multiple YouTube resources (channel, video, ...).
  # This is an abstract class and should not be instantiated directly.
  class Resource
    # @param [Hash] options the options to initialize a resource.
    # @option options [String] :id The unique ID of a YouTube resource.
    def initialize(options = {})
      @data = options
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
      AuthRequest.new(path: path, params: params).run
    end

    def camelize(part)
      part.to_s.gsub(/(?:_|(\/))([a-z\d]*)/i) { "#{$1}#{$2.capitalize}" }
    end

    def self.has_attribute(name, options = {}, &block)
      define_method name do
        keys = Array(options[:in]) + [name]
        value = instance_eval keys.shift.to_s
        keys.each{|key| value = value[camelize key]}
        value = type_cast value, options[:type]
        block_given? ? instance_exec(value, &block) : value
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