module Yt
  module Models
    # Provides methods to authenticate as a YouTube CMS partner.
    # @see https://developers.google.com/youtube/partner/docs/v1/contentOwners
    class ContentOwner < Account
      # @param [Hash] options the options to initialize a Content Owner.
      # @option options [String] :id The unique ID that YouTube uses to
      #   identify the content owner.
      # @option options [String] :refresh_token The refresh token to interact
      #   with the YouTube API on behalf of a content owner.
      def initialize(options = {})
        @id = options[:id]
        super
      end

      # @return [String] the unique ID that identifies a YouTube content owner.
      attr_reader :id
    end
  end
end
