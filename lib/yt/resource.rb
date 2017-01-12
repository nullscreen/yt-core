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


  ### OTHERS

    # @return [String] a representation of the resource instance.
    def inspect
      "#<#{self.class} @id=#{@id}>"
    end
  end
end