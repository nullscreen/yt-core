module Yt
  # Provides methods to interact with YouTube playlists.
  # @see https://developers.google.com/youtube/v3/docs/playlists
  class Playlist < Resource
    # @param [Hash] options the options to initialize a Playlist.
    # @option options [String] :id The unique ID of a YouTube playlist.
    def initialize(options = {})
      super
    end

  ### ID

    # @return [String] the playlist’s ID.
    attr_reader :id

    # @return [String] the canonical form of the playlist’s URL.
    def canonical_url
      "https://www.youtube.com/playlist?list=#{id}"
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

    # @return [String] the ID of the channel that published the playlist.
    def channel_id
      snippet['channelId']
    end

    # @return [String] the title of the channel that published the playlist.
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

  ### ASSOCIATIONS

    # @return [Yt::Relation<Yt::PlaylistItem>] the items of the playlist.
    def items
      @items ||= Relation.new(PlaylistItem) {|options| items_response options}
    end

    # @return [Yt::Relation<Yt::Video>] the videos of the playlist.
    def videos
      @videos ||= Relation.new(Video) {|options| videos_response options}
    end

  ### OTHERS

    # Specifies which parts of the video to fetch when hitting the data API.
    # @param [Array<Symbol, String>] parts The parts to fetch. Valid values
    #   are: +:snippet+, +:status+, and +:content_details+.
    # @return [Yt::Video] itself.
    def select(*parts)
      @selected_data_parts = parts
      self
    end

  private

  ### DATA

    # @return [Array<Symbol>] the parts that can be fetched for a playlist.
    def valid_parts
      %i(snippet status content_details)
    end

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

  ### ASSOCIATIONS (PLAYLIST ITEMS)

    def items_response(options = {})
      Net::HTTP.start 'www.googleapis.com', 443, use_ssl: true do |http|
        http.request items_request(options)
      end.tap{|response| response.body = JSON response.body}
    end

    def items_request(options = {})
      part = options[:parts].join ','
      query = {key: Yt.configuration.api_key, playlistId: id, part: part, maxResults: 50, pageToken: options[:offset]}.to_param

      Net::HTTP::Get.new("/youtube/v3/playlistItems?#{query}").tap do |request|
        request.initialize_http_header 'Content-Type' => 'application/json'
      end
    end

    def videos_response(options = {})
      items = items_response options.merge(parts: [:content_details])

      if options[:parts] == [:id]
        items.tap do |response|
          response.body['items'].map{|item| item['id'] = item['contentDetails']['videoId']}
        end
      else
        videos_list_response(options[:parts], items.body['items'].map{|item| item['contentDetails']['videoId']}).tap do |response|
          response.body['nextPageToken'] = items.body['nextPageToken']
        end
      end
    end

    def videos_list_response(parts, video_ids)
      Net::HTTP.start 'www.googleapis.com', 443, use_ssl: true do |http|
        http.request videos_list_request(parts, video_ids)
      end.tap{|response| response.body = JSON response.body}
    end

    def videos_list_request(parts, video_ids)
      part = parts.join ','
      ids = video_ids.join ','
      query = {key: Yt.configuration.api_key, id: ids, part: part}.to_param

      Net::HTTP::Get.new("/youtube/v3/videos?#{query}").tap do |request|
        request.initialize_http_header 'Content-Type' => 'application/json'
      end
    end
  end
end
