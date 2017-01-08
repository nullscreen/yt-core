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
      if options[:snippet]
        @data[:snippet] = options[:snippet]
      end
      if options[:status]
        @data[:status] = options[:status]
      end
      if options[:statistics]
        @data[:statistics] = options[:statistics]
      end
      if options[:content_details]
        @data[:content_details] = options[:content_details]
      end
    end

  ### ID

    # @return [String] the video’s ID.
    def id
      @id
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

    # @return [Array<String>] the list of keyword tags associated with the
    #   video.
    def tags
      snippet['tags']
    end

    # @return [Integer] the ID of the associated YouTube video category.
    # @see https://developers.google.com/youtube/v3/docs/videoCategories/list
    def category_id
      snippet['categoryId'].to_i
    end

    # List of YouTube video categories.
    # @see https://developers.google.com/youtube/v3/docs/videoCategories/list
    CATEGORIES = {
       1 => 'Film & Animation',
       2 => 'Autos & Vehicles',
      10 => 'Music',
      15 => 'Pets & Animals',
      17 => 'Sports',
      18 => 'Short Movies',
      19 => 'Travel & Events',
      20 => 'Gaming',
      21 => 'Videoblogging',
      22 => 'People & Blogs',
      23 => 'Comedy',
      24 => 'Entertainment',
      25 => 'News & Politics',
      26 => 'Howto & Style',
      27 => 'Education',
      28 => 'Science & Technology',
      29 => 'Nonprofits & Activism',
      30 => 'Movies',
      31 => 'Anime/Animation',
      32 => 'Action/Adventure',
      33 => 'Classics',
      34 => 'Comedy',
      35 => 'Documentary',
      36 => 'Drama',
      37 => 'Family',
      38 => 'Foreign',
      39 => 'Horror',
      40 => 'Sci-Fi/Fantasy',
      41 => 'Thriller',
      42 => 'Shorts',
      43 => 'Shows',
      44 => 'Trailers',
    }

    # @return [String] the title of the associated YouTube video category.
    # @see https://developers.google.com/youtube/v3/docs/videoCategories/list
    def category_title
      CATEGORIES[category_id]
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

    # @return [<String>] the length of the video as an ISO 8601 duration.
    # @see https://developers.google.com/youtube/v3/docs/videos#contentDetails.duration
    def duration
      content_details['duration']
    end

    # @return [<Integer>] the length of the video in seconds.
    def seconds
      to_seconds duration
    end

    # @return [<String>] the length of the video as an ISO 8601 time, HH:MM:SS.
    def length
      hh, mm, ss = seconds / 3600, seconds / 60 % 60, seconds % 60
      [hh, mm, ss].map{|t| t.to_s.rjust(2,'0')}.join(':')
    end

    # @return [String] whether the video is available in 3D or in 2D.
    #   Valid values are: +"2d"+ and +"3d".
    def dimension
      content_details['dimension']
    end

    # @return [String] whether the video is available in high definition or only
    #   in standard definition. Valid values are: +"sd"+ and +"hd".
    def definition
      content_details['definition']
    end

    # @return [Boolean] whether captions are available for the video.
    def caption
      content_details['caption'] == 'true'
    end

    # @return [Boolean] whether the video represents licensed content, which
    #   means that the content was uploaded to a channel linked to a YouTube
    #   content partner and then claimed by that partner.
    def licensed_content
      content_details['licensedContent']
    end

    # @return [String] the projection format of the video. Valid values are:
    #   +"360"+ and +"rectangular".
    def projection
      content_details['projection']
    end

    # def has_custom_thumbnail # not yet implemented
    # def content_rating # not yet implemented

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
      data_part :snippet
    end

    def status
      data_part :status
    end

    def statistics
      data_part :statistics
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

      Net::HTTP::Get.new("/youtube/v3/videos?#{query}").tap do |request|
        request.initialize_http_header 'Content-Type' => 'application/json'
      end
    end

  # OTHERS

  private

    # @return [Integer] the duration of the resource as reported by YouTube.
    # @see https://developers.google.com/youtube/v3/docs/videos
    #
    # According to YouTube documentation, the value is an ISO 8601 duration
    # in the format PT#M#S, in which the letters PT indicate that the value
    # specifies a period of time, and the letters M and S refer to length in
    # minutes and seconds, respectively. The # characters preceding the M and
    # S letters are both integers that specify the number of minutes (or
    # seconds) of the video. For example, a value of PT15M51S indicates that
    # the video is 15 minutes and 51 seconds long.
    #
    # The ISO 8601 duration standard, though, is not +always+ respected by
    # the results returned by YouTube API. For instance: video 2XwmldWC_Ls
    # reports a duration of 'P1W2DT6H21M32S', which is to be interpreted as
    # 1 week, 2 days, 6 hours, 21 minutes, 32 seconds. Mixing weeks with
    # other time units is not strictly part of ISO 8601; in this context,
    # weeks will be interpreted as "the duration of 7 days". Similarly, a
    # day will be interpreted as "the duration of 24 hours".
    # Video tPEE9ZwTmy0 reports a duration of 'PT2S'. Skipping time units
    # such as minutes is not part of the standard either; in this context,
    # it will be interpreted as "0 minutes and 2 seconds".
    def to_seconds(iso8601_duration)
      match = iso8601_duration.match %r{^P(?:|(?<weeks>\d*?)W)(?:|(?<days>\d*?)D)(?:|T(?:|(?<hours>\d*?)H)(?:|(?<min>\d*?)M)(?:|(?<sec>\d*?)S))$}
      weeks = (match[:weeks] || '0').to_i
      days = (match[:days] || '0').to_i
      hours = (match[:hours] || '0').to_i
      minutes = (match[:min] || '0').to_i
      seconds = (match[:sec]).to_i
      (((((weeks * 7) + days) * 24 + hours) * 60) + minutes) * 60 + seconds
    end
  end
end
