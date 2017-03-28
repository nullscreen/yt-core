module Yt
  # Provides a base class for multiple YouTube resources (channel, video, ...).
  # This is an abstract class and should not be instantiated directly.
  class Resource
    # @param [Hash] options the options to initialize a resource.
    # @option options [String] :id The unique ID of a YouTube resource.
    def initialize(options = {})
      @id = options[:id]
      @data = HashWithIndifferentAccess.new
      valid_parts.each do |part|
        @data[part] = options[part] if options[part]
      end
    end

  ### ID

    # @return [String] the resource’s uniqueID.
    attr_reader :id

  ### OTHERS

    # @return [String] a representation of the resource instance.
    def inspect
      "#<#{self.class} @id=#{@id}>"
    end

  private

    def self.has_attribute(name, options = {}, &block)
      define_method name do
        keys = (Array(options[:in]) + [name]).map &:to_s
        value = instance_eval keys.shift
        keys.each{|key| value = value[key.camelize :lower]}
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