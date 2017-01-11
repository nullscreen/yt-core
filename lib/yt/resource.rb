module Yt
  # Provides a base class for multiple YouTube resources (channel, video, ...).
  class Resource    
    # @param [Hash] options the options to initialize a resource.
    # @option options [String] :id The unique ID of a YouTube resource.
    def initialize(options = {})
      @id = options[:id]
    end
  end
end