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

    # @!attribute [r] featured_channels_title
    # @return [<String, nil>] the title that displays above the featured
    #   channels module. The title has a maximum length of 30 characters.
    has_attribute :featured_channels_title, in: %i(branding_settings channel)

    # @!attribute [r] featured_channels_title
    # @return [Array<String>] the IDs of the channels linked in the featured
    #   channels module.
    has_attribute :featured_channels_urls, in: %i(branding_settings channel), default: []

    # @!attribute [r] related_playlists
    # @return [Hash] the playlists associated with the channel, such as the
    #   channel's uploaded videos, liked videos, and watch history.
    has_attribute :related_playlists, in: :content_details

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

    # @return [Yt::Relation<Yt::Video>] the public videos of the channel.
    # @note For unauthenticated channels, results are constrained to a maximum
    # of 500 videos.
    # @see https://developers.google.com/youtube/v3/docs/search/list#channelId
    def videos
      @videos ||= Relation.new(Video, channel_id: id, limit: 500) do |options|
        items = get '/youtube/v3/search', channel_videos_params(options)
        videos_for items, 'id', options
      end
    end

    # @return [Yt::Relation<Yt::Playlist>] the public playlists of the channel.
    def playlists
      @playlists ||= Relation.new(Playlist, channel_id: id) do |options|
        get '/youtube/v3/playlists', channel_playlists_params(options)
      end
    end

    # @return [Yt::Relation<Yt::Playlist>] the playlists associated with
    #   liked videos. Includes the deprecated favorites if still present.
    def like_playlists
      @like_lists ||= Relation.new(Playlist, ids: like_list_ids) do |options|
        get '/youtube/v3/playlists', resource_params(options)
      end
    end

    # @return [Yt::Channel] the channel associated with the YouTube account
    #   that provided the authentication token.
    def self.mine
      Relation.new(self) do |options|
        get '/youtube/v3/channels', mine: true, part: 'id'
      end.first
    end

  private

    def like_list_ids
      names = %w(likes favorites)
      related_playlists.select{|name,_| names.include? name}.values
    end
  end
end
