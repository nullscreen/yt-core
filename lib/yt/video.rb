module Yt
  # Provides methods to interact with YouTube videos.
  # @see https://developers.google.com/youtube/v3/docs/videos
  class Video
    # @param [Hash] options the options to initialize a Channel.
    # @option options [String] :id The unique ID of a YouTube channel.
    def initialize(options = {})
      @id = options[:id]
      @auth = options[:auth]
      @data = HashWithIndifferentAccess.new
      @data[:snippet] = options[:snippet] if options[:snippet]
    end

  ### SNIPPET

    # @return [Time] the date and time that the video was published. Note that
    #   this time might be different than the time that the video was uploaded.
    #   For example, if a video is uploaded as a private video and then made
    #   public at a later time, this property will specify the time that the
    #   video was made public.
    def published_at
      Time.parse snippet['publishedAt']
    end

    # @return [String] the ID that YouTube uses to uniquely identify the channel
    #   that the video was uploaded to.
    def channel_id
      snippet['channelId']
    end

    # @return [String] the video’s title. Has a maximum length of 100 characters
    #   and may contain all valid UTF-8 characters except < and >.
    def title
      snippet['title']
    end

    # @return [String] the video’s description. Has a maximum length of 5000
    #   bytes and may contain all valid UTF-8 characters except < and >.
    def description
      snippet['description']
    end

    # Returns the URL of the video’s thumbnail.
    # @param [Symbol, String] size The size of the video’s thumbnail.
    # @return [String] if +size+ is +:default+, the URL of a 120x90px image.
    # @return [String] if +size+ is +:medium+, the URL of a 320x180px image.
    # @return [String] if +size+ is +:high+, the URL of a 480x360px image.
    # @return [String] if +size+ is +:standard+, the URL of a 640x480px image.
    # @return [String] if +size+ is +:maxres+, the URL of a 1280x720px image.
    # @return [nil] if the +size+ is none of the above.
    def thumbnail_url(size = :default)
      snippet['thumbnails'].fetch(size.to_s, {})['url']
    end

    # @return [String] the title of the channel that the video belongs to.
    def channel_title
      snippet['channelTitle']
    end

    # @return [Array] the list of keyword tags associated with the video.
    def tags
      snippet['tags']
    end

    # @return [Integer] the ID of the associated YouTube video category.
    # @see https://developers.google.com/youtube/v3/docs/videoCategories/list
    def category_id
      snippet['categoryId'].to_i
    end

    # @return [String] whether the video is an upcoming/active live broadcast.
    #   Valid values are: +"live"+, +"none"+, +"upcoming"+.
    def live_broadcast_content
      snippet['liveBroadcastContent']
    end

    # def default_language # not yet implemented, not sure how to set to test
    # def localized # not yet implemented
    # def default_audio_language # not yet implemented, not sure how to set to test

  ### STATUS

    # @return [String] the status of the uploaded video. Valid values are:
    #   +"deleted"+, +"failed"+, +"processed"+, +"rejected"+, and +"unlisted"+.
    def upload_status
      status['uploadStatus']
    end

    # @return [String] the video’s privacy status. Valid values are:
    #   +"private"+, +"public"+, and +"unlisted"+.
    def privacy_status
      status['privacyStatus']
    end

    # @return [String] the video’s license. Valid values are:
    #   +"creative_common"+ and +"youtube"+.
    def license
      status['license']
    end

    # @return [Boolean] whether the video can be embedded on another website.
    def embeddable
      status['embeddable']
    end

    # @return [Boolean] whether the extended video statistics on the video’s
    #   watch page are publicly viewable.
    def public_stats_viewable
      status['publicStatsViewable']
    end

    # def failure_reason # not yet implemented
    # def rejection_reason # not yet implemented
    # def publish_at # not yet implemented

  ### STATISTICS

    # @return [<Integer>] the number of times the video has been viewed.
    def view_count
      statistics['viewCount'].to_i
    end

    # @return [<Integer>] the number of users who have indicated that they
    #   liked the video.
    def like_count
      statistics['likeCount'].to_i
    end

    # @return [<Integer>] the number of users who have indicated that they
    #   disliked the video.
    def dislike_count
      statistics['dislikeCount'].to_i
    end

    # @return [<Integer>] the number of comments for the video.
    def comment_count
      statistics['commentCount'].to_i
    end

  ### CONTENT DETAILS


  ### OTHERS

    # Specifies which parts of the video to fetch when hitting the data API.
    # @param [Array<Symbol, String>] parts The parts to fetch. Valid values
    #   are: +:snippet+, +:status+, +:statistics+, and +:content_details+.
    # @return [Yt::Video] itself.
    def select(*parts)
      @selected_data_parts = parts
      self
    end

    # @return [String] a representation of the Yt::Video instance.
    def inspect
      "#<#{self.class} @id=#{@id}>"
    end

  private

  ### DATA

    def snippet
      data_part 'snippet'
    end

    def status
      data_part 'status'
    end

    def statistics
      data_part 'statistics'
    end

    def content_details
      data_part 'contentDetails'
    end

    def data_part(part)
      @data[part] || fetch_data(part)
    end

    def fetch_data(part)
      parts = @selected_data_parts || [part]
      if (items = data_response(parts).body['items']).any?
        parts.each{|part| @data[part] = items.first[part.to_s]}
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

      Net::HTTP::Get.new("/youtube/v3/videos?#{query}").tap do |request|
        request.initialize_http_header 'Content-Type' => 'application/json'
      end
    end
  end
end
