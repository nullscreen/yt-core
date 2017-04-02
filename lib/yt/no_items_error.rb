module Yt
  # Raised when items are expected from YouTube but none are returned.
  # @example Fetch the title of a channel with an unknown ID.
  #   Yt::Channel.new(id: 'unknown-id').title
  #   # => raise Yt::NoItemsError
  class NoItemsError < StandardError
  end
end
