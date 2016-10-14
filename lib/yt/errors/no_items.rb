module Yt
  module Errors
    # Raised when items are expected from YouTube but none are returned.
    # @example Fetch the title of a channel with an unknown ID.
    #   Yt::Channel.new(id: 'unknown-id').title
    #   # => raise Yt::Errors::NoItems
    class NoItems < StandardError
    end
  end
end
