module Yt
  # Provides methods to interact with YouTube videos.
  # @see https://developers.google.com/youtube/v3/docs/videos
  class Video < Resource
    # @!attribute [r] title
    # @return [String] the video’s title. Has a maximum length of 100 characters
    #   and may contain all valid UTF-8 characters except < and >.
    has_attribute :title, in: :snippet

    # @!attribute [r] description
    # @return [String] the video’s description. Has a maximum length of 5000
    #   bytes and may contain all valid UTF-8 characters except < and >.
    has_attribute :description, in: :snippet

    # @!attribute [r] published_at
    # @return [Time] the date and time that the video was published. Note that
    #   this time might be different than the time that the video was uploaded.
    #   For example, if a video is uploaded as a private video and then made
    #   public at a later time, this property will specify the time that the
    #   video was made public.
    has_attribute :published_at, in: :snippet, type: Time

    # @!attribute [r] thumbnails
    # @return [Hash<String, Hash>] the thumbnails associated with the video.
    has_attribute :thumbnails, in: :snippet

    # @!attribute [r] channel_id
    # @return [String] the ID of the channel that the video was uploaded to.
    has_attribute :channel_id, in: :snippet

    # @!attribute [r] channel_title
    # @return [String] the title of the channel that the video was uploaded to.
    has_attribute :channel_title, in: :snippet

    # @!attribute [r] tags
    # @return [Array<String>] the list of tags associated with the video.
    has_attribute :tags, in: :snippet

    # @!attribute [r] category_id
    # @return [Integer] the ID of the associated YouTube video category.
    # @see https://developers.google.com/youtube/v3/docs/videoCategories/list
    has_attribute :category_id, in: :snippet, type: Integer

    # @!attribute [r] live_broadcast_content
    # @return [String] whether the video is an upcoming/active live broadcast.
    #   Valid values are: +"live"+, +"none"+, +"upcoming"+.
    has_attribute :live_broadcast_content, in: :snippet

    # has_attribute :default_language, in: :snippet not sure how to set to test
    # has_attribute :localized, in: :snippet not yet implemented
    # has_attribute :default_audio_language, in: :snippet not sure how to test

    # @!attribute [r] upload_status
    # @return [String] the status of the uploaded video. Valid values are:
    #   +"deleted"+, +"failed"+, +"processed"+, +"rejected"+, and +"unlisted"+.
    has_attribute :upload_status, in: :status

    # @!attribute [r] privacy_status
    # @return [String] the video’s privacy status. Valid values are:
    #   +"private"+, +"public"+, and +"unlisted"+.
    has_attribute :privacy_status, in: :status

    # @!attribute [r] license
    # @return [String] the video’s license. Valid values are:
    #   +"creative_common"+ and +"youtube"+.
    has_attribute :license, in: :status

    # @!attribute [r] embeddable
    # @return [Boolean] whether the video can be embedded on another website.
    has_attribute :embeddable, in: :status

    # @!attribute [r] public_stats_viewable
    # @return [Boolean] whether the extended video statistics on the video’s
    #   watch page are publicly viewable.
    has_attribute :public_stats_viewable, in: :status

    # has_attribute :failure_reason, in: :status not yet implemented
    # has_attribute :rejection_reason, in: :status not yet implemented
    # has_attribute :publish_at, in: :status not yet implemented

    # @!attribute [r] view_count
    # @return [<Integer>] the number of times the video has been viewed.
    has_attribute :view_count, in: :statistics, type: Integer

    # @!attribute [r] like_count
    # @return [<Integer>] the number of users who have liked the video.
    has_attribute :like_count, in: :statistics, type: Integer

    # @!attribute [r] dislike_count
    # @return [<Integer>] the number of users who have disliked the video.
    has_attribute :dislike_count, in: :statistics, type: Integer

    # @!attribute [r] comment_count
    # @return [<Integer>] the number of comments for the video.
    has_attribute :comment_count, in: :statistics, type: Integer

    # @!attribute [r] duration
    # @return [<String>] the length of the video as an ISO 8601 duration.
    # @see https://developers.google.com/youtube/v3/docs/videos#contentDetails.duration
    has_attribute :duration, in: :content_details

    # @!attribute [r] dimension
    # @return [String] whether the video is available in 3D or in 2D.
    #   Valid values are: +"2d"+ and +"3d".
    has_attribute :dimension, in: :content_details

    # @!attribute [r] definition
    # @return [String] whether the video is available in high definition or only
    #   in standard definition. Valid values are: +"sd"+ and +"hd".
    has_attribute :definition, in: :content_details

    # @!attribute [r] caption
    # @return [Boolean] whether captions are available for the video.
    has_attribute :caption, in: :content_details do |captioned|
      captioned == 'true'
    end

    # @!attribute [r] licensed_content
    # @return [Boolean] whether the video represents licensed content, which
    #   means that the content was uploaded to a channel linked to a YouTube
    #   content partner and then claimed by that partner.
    has_attribute :licensed_content, in: :content_details

    # @!attribute [r] projection
    # @return [String] the projection format of the video. Valid values are:
    #   +"360"+ and +"rectangular".
    has_attribute :projection, in: :content_details

    # has_attribute :has_custom_thumbnail, in: :content_details to do
    # has_attribute :content_rating, in: :content_details to do

  ### OTHER METHODS

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

    # @return [String] the canonical form of the video’s URL.
    def canonical_url
      "https://www.youtube.com/watch?v=#{id}"
    end

    # @return [Hash<Integer, String>] the list of YouTube video categories.
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
    def category_title
      CATEGORIES[category_id]
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

  ### ASSOCIATIONS

    # @return [Yt::Channel] the channel the video belongs to.
    def channel
      @channel ||= Channel.new id: channel_id
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

      request = AuthRequest.new({
        path: "/youtube/v3/videos",
        params: {key: Yt.configuration.api_key, id: @id, part: parts.join(',')}
      })

      if (items = request.run.body['items']).any?
        parts.each{|part| @data[part] = items.first[part.to_s.camelize :lower]}
        @data[part]
      else
        raise Errors::NoItems
      end
    end

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
