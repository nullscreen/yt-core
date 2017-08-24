module Yt
  # Provides methods to interact with YouTube playlists.
  # @see https://developers.google.com/youtube/v3/docs/playlists
  class Playlist < Resource
    # @!attribute [r] title
    #   @return [String] the playlist’s title.
    has_attribute :title, in: :snippet

    # @!attribute [r] description
      # @return [String] the playlist’s description.
    has_attribute :description, in: :snippet

    # @!attribute [r] published_at
    # @return [Time] the date and time that the playlist was created.
    has_attribute :published_at, in: :snippet, type: Time

    # @!attribute [r] thumbnails
    # @return [Hash<String, Hash>] the thumbnails associated with the playlist.
    has_attribute :thumbnails, in: :snippet

    # @!attribute [r] channel_id
    # @return [String] the ID of the channel that published the playlist.
    has_attribute :channel_id, in: :snippet

    # @!attribute [r] channel_title
    # @return [String] the title of the channel that published the playlist.
    has_attribute :channel_title, in: :snippet

    # has_attribute :default_language, in: :snippet not sure how to set to test
    # has_attribute :localized, in: :snippet not yet implemented
    # has_attribute :tags, in: :snippet not sure how to set to test

    # @!attribute [r] privacy_status
    # @return [String] the playlist’s privacy status. Valid values are:
    #   +"private"+, +"public"+, and +"unlisted"+.
    has_attribute :privacy_status, in: :status

    # @!attribute [r] item_count
    # @return [<Integer>] the number of videos in the playlist.
    has_attribute :item_count, in: :content_details, type: Integer

    # Returns the URL of the playlist’s thumbnail.
    # @param [Symbol, String] size The size of the playlist’s thumbnail.
    # @return [String] if +size+ is +:default+, the URL of a 120x90px image.
    # @return [String] if +size+ is +:medium+, the URL of a 320x180px image.
    # @return [String] if +size+ is +:high+, the URL of a 480x360px image.
    # @return [String] if +size+ is +:standard+, the URL of a 640x480px image.
    # @return [String] if +size+ is +:maxres+, the URL of a 1280x720px image.
    # @return [nil] if the +size+ is none of the above.
    def thumbnail_url(size = :default)
      thumbnails.fetch(size.to_s, {})['url']
    end

    # @return [String] the canonical form of the playlist’s URL.
    def canonical_url
      "https://www.youtube.com/playlist?list=#{id}"
    end

    # @return [Yt::Relation<Yt::PlaylistItem>] the items of the playlist.
    def items
      @items ||= Relation.new(PlaylistItem, playlist_id: id) do |options|
        get '/youtube/v3/playlistItems', playlist_items_params(options)
      end
    end

    # @return [Yt::Relation<Yt::Video>] the videos of the playlist.
    def videos
      @videos ||= Relation.new(Video, playlist_id: id) do |options|
        params = playlist_items_params(options.merge parts: [:content_details])
        items = get '/youtube/v3/playlistItems', params
        videos_for items, 'contentDetails', options
      end
    end
  end
end
