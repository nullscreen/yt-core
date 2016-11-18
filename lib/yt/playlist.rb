module Yt
  # Provides methods to interact with YouTube playlists.
  # @see https://developers.google.com/youtube/v3/docs/playlists
  class Playlist
    # @param [Hash] options the options to initialize a Playlist.
    # @option options [String] :id The unique ID of a YouTube playlist.
    def initialize(options = {})
      @id = options[:id]
      @data = HashWithIndifferentAccess.new
    end

  ### ID

    # @return [String] the video’s ID.
    def id
      @id
    end

  ### SNIPPET

    # @return [String] the playlist’s title.
    def title
      snippet['title']
    end

    # @return [String] the playlist’s description.
    def description
      snippet['description']
    end

    # @return [Time] the date and time that the playlist was created.
    def published_at
      Time.parse snippet['publishedAt']
    end

    # Returns the URL of the playlist’s thumbnail.
    # @param [Symbol, String] size The size of the playlist’s thumbnail.
    # @return [String] if +size+ is +:default+, the URL of a 120x90px image.
    # @return [String] if +size+ is +:medium+, the URL of a 320x180px image.
    # @return [String] if +size+ is +:high+, the URL of a 480x360px image.
    # @return [String] if +size+ is +:standard+, the URL of a 640x480px image.
    # @return [String] if +size+ is +:maxres+, the URL of a 1280x720px image.
    # @return [nil] if the +size+ is none of the above.
    def thumbnail_url(size = :default)
      snippet['thumbnails'].fetch(size.to_s, {})['url']
    end

    # @return [String] the ID of the channelthat published the playlist.
    def channel_id
      snippet['channelId']
    end

    # @return [String] the of the channel that published the playlist.
    def channel_title
      snippet['channelTitle']
    end

    # def tags # not yet implemented, not sure how to set to test
    # def default_language # not yet implemented, not sure how to set to test
    # def localized # not yet implemented

  ### STATUS

    # @return [String] the playlist’s privacy status. Valid values are:
    #   +"private"+, +"public"+, and +"unlisted"+.
    def privacy_status
      status['privacyStatus']
    end

  ### CONTENT DETAILS

    # @return [<Integer>] the number of videos in the playlist.
    def item_count
      content_details['itemCount']
    end

  ### OTHERS

    # Specifies which parts of the video to fetch when hitting the data API.
    # @param [Array<Symbol, String>] parts The parts to fetch. Valid values
    #   are: +:snippet+, +:status+, +:statistics+, and +:content_details+.
    # @return [Yt::Video] itself.
    def select(*parts)
      @selected_data_parts = parts
      self
    end

    # @return [String] a representation of the Yt::Playlist instance.
    def inspect
      "#<#{self.class} @id=#{@id}>"
    end

  private

  ### DATA

    def snippet
      data_part :snippet
    end

    def status
      data_part :status
    end

    def content_details
      data_part :content_details
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

      Net::HTTP::Get.new("/youtube/v3/playlists?#{query}").tap do |request|
        request.initialize_http_header 'Content-Type' => 'application/json'
      end
    end
  end
end
