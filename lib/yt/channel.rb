module Yt
  # Provides methods to interact with YouTube channels.
  # @see https://developers.google.com/youtube/v3/docs/channels
  class Channel < Resource
    # @!attribute [r] title
    # @return [String] the channel’s title.
    has_attribute :title, in: :snippet

    # @!attribute [r] description
    # @return [String] the channel’s description.
    has_attribute :description, in: :snippet

    # @!attribute [r] published_at
    # @return [Time] the date and time that the channel was created.
    has_attribute :published_at, in: :snippet, type: Time

    # @!attribute [r] thumbnails
    # @return [Hash<String, Hash>] the thumbnails associated with the video.
    has_attribute :thumbnails, in: :snippet

    # @!attribute [r] custom_url
    # @return [<String, nil>] the path component of the channel’s custom URL.
    has_attribute :custom_url, in: :snippet

    # has_attribute :default_language, in: :snippet not sure how to set to test
    # has_attribute :localized, in: :snippet not yet implemented
    # has_attribute :country, in: :snippet not sure how to set to test

    # @!attribute [r] privacy_status
    # @return [String] the privacy status of the channel. Valid values are:
    #   +"private"+, +"public"+, +"unlisted"+.
    has_attribute :privacy_status, in: :status

    # @!attribute [r] is_linked
    # @return [Boolean] whether the channel data identifies a user that is
    #   already linked to either a YouTube username or a Google+ account.
    has_attribute :is_linked, in: :status

    # @!attribute [r] long_uploads_status
    # @return [String] whether the channel is eligible to upload videos that
    #   are more than 15 minutes long. Valid values are: +"allowed"+,
    #   +"disallowed"+, +"eligible"+, +"longUploadsUnspecified"+.
    # @note +"longUploadsUnspecified"+ is not documented by the YouTube API.
    has_attribute :long_uploads_status, in: :status

    # @!attribute [r] view_count
    # @return [<Integer>] the number of times the channel has been viewed.
    has_attribute :view_count, in: :statistics, type: Integer

    # @!attribute [r] comment_count
    # @return [<Integer>] the number of comments for the channel.
    has_attribute :comment_count, in: :statistics, type: Integer

    # @!attribute [r] subscriber_count
    # @return [<Integer>] the number of subscribers that the channel has.
    has_attribute :subscriber_count, in: :statistics, type: Integer

    # @!attribute [r] hidden_subscriber_count
    # @return [<Boolean>] whether the channel’s subscriber count is publicly
    #   visible.
    has_attribute :hidden_subscriber_count, in: :statistics

    # @!attribute [r] video_count
    # @return [<Integer>] the number of videos uploaded to the channel.
    has_attribute :video_count, in: :statistics, type: Integer

    # @!attribute [r] banner_image_url
    # @return [String] the URL for the banner image shown on the channel page
    #   on the YouTube website. The image is 1060px by 175px.
    has_attribute :banner_image_url, in: %i(branding_settings image)

    # @!attribute [r] keywords
    # @return [Array<String>] the keywords associated with the channel.
    has_attribute :keywords, in: %i(branding_settings channel) do |keywords|
      (keywords || '').split ' '
    end

    # @!attribute [r] unsubscribed_trailer
    # @return [<String, nil>] if specified, the ID of a public or unlisted video
    #   owned by the channel owner that should play in the featured video module
    #   in the channel page’s browse view for unsubscribed viewers.
    has_attribute :unsubscribed_trailer, in: %i(branding_settings channel)

  ### OTHER METHODS

    # @return [String] the canonical form of the channel’s URL.
    def canonical_url
      "https://www.youtube.com/channel/#{id}"
    end

    # @return [<String] the full channel’s URL (custom or canonical).
    # @see https://support.google.com/youtube/answer/2657968
    def vanity_url
      if custom_url
        "https://www.youtube.com/#{custom_url}"
      else
        canonical_url
      end
    end

    # Returns the URL of one of the channel’s thumbnail.
    # @param [Symbol, String] size The size of the channel’s thumbnail.
    # @return [String] if +size+ is +:default+, the URL of a 88x88px image.
    # @return [String] if +size+ is +:medium+, the URL of a 240x240px image.
    # @return [String] if +size+ is +:high+, the URL of a 800x800px image.
    # @return [nil] if the +size+ is none of the above.
    def thumbnail_url(size = :default)
      thumbnails.fetch(size.to_s, {})['url']
    end

  ### ASSOCIATIONS

    # @return [Yt::Relation<Yt::Video>] the public videos of the channel.
    # @note For unauthenticated channels, results are constrained to a maximum
    # of 500 videos.
    # @see https://developers.google.com/youtube/v3/docs/search/list#channelId
    def videos
      @videos ||= Relation.new(Video, limit: 500) do |options|
        request = AuthRequest.new({
          path: "/youtube/v3/search",
          params: {key: Yt.configuration.api_key, type: :video, channel_id: id, part: :id, max_results: 50, page_token: options[:offset], order: :date}
        })

        # /search only returns id and partial snippets. for any other part we
        # need a second call to /channels
        search = request.run

        if options[:parts] == [:id]
          search.tap do |response|
            response.body['items'].map{|item| item['id'] = item['id']['videoId']}
          end
        else
          ids = search.body['items'].map{|item| item['id']['videoId']}.join ','
          part = options[:parts].join ','
          request = AuthRequest.new({
            path: "/youtube/v3/videos",
            params: {key: Yt.configuration.api_key, id: ids, part: part}
          })
          request.run.tap do |response|
            response.body['nextPageToken'] = search.body['nextPageToken']
          end
        end
      end
    end

    # @return [Yt::Relation<Yt::Playlist>] the public playlists of the channel.
    def playlists
      @playlists ||= Relation.new(Playlist) do |options|
        part = options[:parts].join ','

        request = AuthRequest.new({
          path: "/youtube/v3/playlists",
          params: {key: Yt.configuration.api_key, channel_id: id, part: part, max_results: 50, page_token: options[:offset]}
        })

        request.run
      end
    end

  ### OTHERS

    # Specifies which parts of the channel to fetch when hitting the data API.
    # @param [Array<Symbol, String>] parts The parts to fetch. Valid values
    #   are: +:snippet+, +:status+, +:branding_settings+, and +:statistics+.
    # @return [Yt::Channel] itself.
    def select(*parts)
      @selected_data_parts = parts
      self
    end

  private

  ### DATA

    # @return [Array<Symbol>] the parts that can be fetched for a channel.
    def valid_parts
      %i(snippet status statistics branding_settings)
    end

    def snippet
      data_part 'snippet'
    end

    def status
      data_part 'status'
    end

    def branding_settings
      data_part 'branding_settings'
    end

    def statistics
      data_part 'statistics'
    end

    def data_part(part)
      @data[part] || fetch_data(part)
    end

    def fetch_data(part)
      parts = @selected_data_parts || [part]

      request = AuthRequest.new({
        path: "/youtube/v3/channels",
        params: {key: Yt.configuration.api_key, id: @id, part: parts.join(',')}
      })

      if (items = request.run.body['items']).any?
        parts.each{|part| @data[part] = items.first[part.to_s.camelize :lower]}
        @data[part]
      else
        raise Errors::NoItems
      end
    end

  ### COLLECTION

    # @return [Yt::Relation<Yt::Channel>] the channels matching the conditions.
    def self.where(conditions = {})
      @where ||= Relation.new(Channel) do |options|
        id = options[:conditions].fetch(:id, []).join ','
        part = options[:parts].join ','

        request = AuthRequest.new({
          path: "/youtube/v3/channels",
          params: {key: Yt.configuration.api_key, id: id, part: part}
        })

        request.run
      end
      @where.where conditions
    end
  end
end