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
    has_attribute :privacy_status, in: :status

  ### OTHER METHODS

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

  ### OTHERS

    # Specifies which parts of the video to fetch when hitting the data API.
    # @param [Array<Symbol, String>] parts The parts to fetch. Valid values
    #   are: +:snippet+ and +:status+.
    # @return [Yt::Video] itself.
    def select(*parts)
      @selected_data_parts = parts
      self
    end

  private

  ### DATA

    # @return [Array<Symbol>] the parts that can be fetched for a playlist item.
    def valid_parts
      %i(snippet status)
    end

    def snippet
      data_part :snippet
    end

    def status
      data_part :status
    end

    def data_part(part)
      @data[part] || fetch_data(part)
    end

    def fetch_data(part)
      parts = @selected_data_parts || [part]

      request = AuthRequest.new({
        path: "/youtube/v3/playlistItems",
        params: {key: Yt.configuration.api_key, id: @id, part: parts.join(',')}
      })

      if (items = request.run.body['items']).any?
        parts.each{|part| @data[part] = items.first[part.to_s.camelize :lower]}
        @data[part]
      else
        raise Errors::NoItems
      end
    end
  end
end
