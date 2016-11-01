module Yt
  # Provides methods to identify YouTube resources from canonical URLs.
  # @see https://developers.google.com/youtube/v3/docs
  # @example Identify a YouTube video from its short URL:
  #   url = Yt::URL.new 'youtu.be/9bZkp7q19f0'
  #   url.kind # => :video
  class URL
    # @param [String] url the canonical URL of a YouTube resource to identify.
    def initialize(url)
      @url = url.to_s.strip
      @match = find_pattern_match
    end

  ### PATTERN MATCHING

    # @return [Symbol] the kind of YouTube resource matching the URL.
    # Possible values are: +:playlist+, +:subscription+, +:video+,
    # +:channel+, and +:unknown:.
    def kind
      @match[:kind]
    end

    # @return [<String, nil>] the ID of the YouTube resource matching the URL.
    def id
      @match[:id]
    end

    # @return [<String, nil>] the username of the YouTube resource matching
    # the URL. Returns +nil+ unless the resource is a channel.
    def username
      @match[:username]
    end

    # @return [Array<Regexp>] patterns matching URLs of YouTube playlists.
    PLAYLIST_PATTERNS = %W{
      ^(?:https?://)?(?:www\.)?youtube\\.com/playlist\\?list=(?<id>[a-zA-Z0-9_-]+)
    }

    # @return [Array<Regexp>] patterns matching URLs of YouTube videos.
    VIDEO_PATTERNS = %W{
      ^(?:https?://)?(?:www\.)?youtube\\.com/watch\\?v=(?<id>[a-zA-Z0-9_-]+)
      ^(?:https?://)?(?:www\.)?youtu\\.be/(?<id>[a-zA-Z0-9_-]+)(?:|/)
      ^(?:https?://)?(?:www\.)?youtube\\.com/embed/(?<id>[a-zA-Z0-9_-]+)(?:|/)
      ^(?:https?://)?(?:www\.)?youtube\\.com/v/(?<id>[a-zA-Z0-9_-]+)(?:|/)
    }

    # @return [Array<Regexp>] patterns matching URLs of YouTube channels.
    CHANNEL_PATTERNS = %W{
      ^(?:https?://)?(?:www\.)?youtube\\.com/channel/(?<id>[a-zA-Z0-9_-]+)(?:|/)
      ^(?:https?://)?(?:www\.)?youtube\\.com/user/(?<username>[a-zA-Z0-9_-]+)(?:|/)
      ^(?:https?://)?(?:www\.)?youtube\\.com/(?<username>[a-zA-Z0-9_-]+)(?:|/)
    }

  ### CANONICAL FORMS

    # @return [String] the canonical form of the URL based on the resource kind.
    def canonical
      case kind
      when :playlist
        "https://www.youtube.com/playlist?list=#{id}"
      when :channel
        "https://www.youtube.com/#{id ? "channel/#{id}" : "user/#{username}"}"
      when :video
        "https://www.youtube.com/watch?v=#{id}"
      when :unknown
        @url
      end
    end

  ### OTHERS

    # @return [String] a representation of the Yt::URL instance.
    def inspect
      "#<#{self.class} @kind=#{kind} @id=#{id}>"
    end

  private

  ### PATTERN MATCHING

    def find_pattern_match
      patterns.find(-> {{kind: :unknown}}) do |kind, regex|
        if data = @url.match(regex)
          # Note: With Ruby 2.4, the following is data.named_captures
          match = data.names.zip(data.captures).to_h.with_indifferent_access
          break match.merge kind: kind
        end
      end
    end

    def patterns
      # @note: :channel *must* be the last since one of its regex eats the
      # remaining patterns. In short, don't change the following order.
      Enumerator.new do |patterns|
        PLAYLIST_PATTERNS.each {|regex| patterns << [:playlist, regex]}
        VIDEO_PATTERNS.each {|regex| patterns << [:video, regex]}
        CHANNEL_PATTERNS.each {|regex| patterns << [:channel, regex]}
      end
    end
  end
end
