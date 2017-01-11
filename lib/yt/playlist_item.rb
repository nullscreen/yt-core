module Yt
  # Provides methods to interact with YouTube playlist items.
  # @see https://developers.google.com/youtube/v3/docs/playlistItems
  class PlaylistItem < Resource
    # @param [Hash] options the options to initialize a PlaylistItem.
    # @option options [String] :id The unique ID of a YouTube playlist item.
    def initialize(options = {})
      super
    end

  ### ID

    # @return [String] the item’s ID.
    def id
      @id
    end

  ### SNIPPET

    # @return [String] the item’s title.
    def title
      snippet['title']
    end

    # @return [String] the item’s description.
    def description
      snippet['description']
    end

    # @return [Time] the date and time that the item was added to the playlist.
    def published_at
      Time.parse snippet['publishedAt']
    end

    # Returns the URL of the item’s thumbnail.
    # @param [Symbol, String] size The size of the item’s thumbnail.
    # @return [String] if +size+ is +:default+, the URL of a 120x90px image.
    # @return [String] if +size+ is +:medium+, the URL of a 320x180px image.
    # @return [String] if +size+ is +:high+, the URL of a 480x360px image.
    # @return [String] if +size+ is +:standard+, the URL of a 640x480px image.
    # @return [String] if +size+ is +:maxres+, the URL of a 1280x720px image.
    # @return [nil] if the +size+ is none of the above.
    def thumbnail_url(size = :default)
      snippet['thumbnails'].fetch(size.to_s, {})['url']
    end

    # @return [String] the ID of the channel that the playlist belongs to.
    def channel_id
      snippet['channelId']
    end

    # @return [String] the title of the channel that the playlist belongs to.
    def channel_title
      snippet['channelTitle']
    end

    # @return [String] the ID of the playlist that the item belongs to.
    def playlist_id
      snippet['playlistId']
    end

    # @return [Integer] the order in which the item appears in the playlist.
    #   The value uses a zero-based index so the first item has a position of 0.
    def position
      snippet['position']
    end

    # @return [String] the ID of the video that the item refers to.
    def video_id
      snippet['resourceId']['videoId']
    end

  ### STATUS

    # @return [String] the item’s privacy status. Valid values are:
    #   +"private"+, +"public"+, and +"unlisted"+.
    def privacy_status
      status['privacyStatus']
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
      if (items = data_response(parts).body['items']).any?
        parts.each{|part| @data[part] = items.first[part.to_s.camelize :lower]}
        @data[part]
      else
        raise Errors::NoItems
      end
    end

    def data_response(parts)
      Net::HTTP.start 'www.googleapis.com', 443, use_ssl: true do |http|
        http.request data_request(parts)
      end.tap{|response| response.body = JSON response.body}
    end

    def data_request(parts)
      part = parts.join ','
      query = {key: Yt.configuration.api_key, id: @id, part: part}.to_param

      Net::HTTP::Get.new("/youtube/v3/playlistItems?#{query}").tap do |request|
        request.initialize_http_header 'Content-Type' => 'application/json'
      end
    end
  end
end
