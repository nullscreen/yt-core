module Yt
  # Provides methods to interact with YouTube playlist items.
  # @see https://developers.google.com/youtube/v3/docs/playlistItems
  class PlaylistItem < Resource
    # @!attribute [r] title
    #   @return [String] the item’s title.
    has_attribute :title, in: :snippet

    # @!attribute [r] description
      # @return [String] the item’s description.
    has_attribute :description, in: :snippet

    # @!attribute [r] published_at
    # @return [Time] the date and time that the item was added to the playlist.
    has_attribute :published_at, in: :snippet, type: Time

    # @!attribute [r] thumbnails
    # @return [Hash<String, Hash>] the thumbnails associated with the item.
    has_attribute :thumbnails, in: :snippet

    # @!attribute [r] channel_id
    # @return [String] the ID of the channel that the playlist belongs to.
    has_attribute :channel_id, in: :snippet

    # @!attribute [r] channel_title
    # @return [String] the title of the channel that the playlist belongs to.
    has_attribute :channel_title, in: :snippet

    # @!attribute [r] playlist_id
    # @return [String] the ID of the playlist that the item belongs to.
    has_attribute :playlist_id, in: :snippet

    # @!attribute [r] position
    # @return [Integer] the order in which the item appears in the playlist.
    #   The value uses a zero-based index so the first item has a position of 0.
    has_attribute :position, in: :snippet, type: Integer

    # @!attribute [r] video_id
    # @return [String] the ID of the video that the item refers to.
    has_attribute :video_id, in: %i(snippet resource_id)

    # @!attribute [r] privacy_status
    # @return [String] the item’s privacy status. Valid values are:
    #   +"private"+, +"public"+, and +"unlisted"+.
    # @return [nil] if the item does not have status (removed video).
    def privacy_status
      status['privacyStatus'] if status
    end
    has_attribute :status

    # Returns the URL of the item’s thumbnail.
    # @param [Symbol, String] size The size of the item’s thumbnail.
    # @return [String] if +size+ is +:default+, the URL of a 120x90px image.
    # @return [String] if +size+ is +:medium+, the URL of a 320x180px image.
    # @return [String] if +size+ is +:high+, the URL of a 480x360px image.
    # @return [String] if +size+ is +:standard+, the URL of a 640x480px image.
    # @return [String] if +size+ is +:maxres+, the URL of a 1280x720px image.
    # @return [nil] if the +size+ is none of the above.
    def thumbnail_url(size = :default)
      thumbnails.fetch(size.to_s, {})['url']
    end

    # @return [Yt::PlaylistItem] the item created by appending the given
    #   video to the given playlist.
    def self.insert(playlist_id:, video_id:)
      parts = %i(id snippet)
      items = -> (body) { [body] } # the response body only includes one item
      resource_id = {kind: 'youtube#video', videoId: video_id}
      snippet = {playlistId: playlist_id, resourceId: resource_id}

      Relation.new(self, parts: parts, extract_items: items) do |options|
        post '/youtube/v3/playlistItems', {part: 'snippet'}, {snippet: snippet}
      end.first
    end

    # @return [Boolean] whether the item was removed from the playlist.
    def delete
      items = -> (body) { [{}] } # the response body is empty

      Relation.new(PlaylistItem, id: id, extract_items: items) do |options|
        delete '/youtube/v3/playlistItems', id: options[:id]
      end.any?
    end
  end
end
