module Yt
  module Models
    # Provides methods to interact with YouTube content owners.
    # A contentOwner resource represents an organization or other entity that
    # owns content or administers content on YouTube.
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

    ### OVERVIEW

      # @return [String] the content owner’s display name.
      # @see https://developers.google.com/youtube/partner/docs/v1/contentOwners#displayName
      def display_name
        @display_name ||= if (items = overview_response.body['items']).any?
          items.first['displayName']
        else
        end
      end

    ### ASSOCIATIONS

      # @return [Array<Yt::Channel>] the channels partnered with the YouTube
      #   content owner.
      def partnered_channels
        Yt::Relation.new do |channels, options = {}|
          parts = (options[:parts] || []) + [:id]
          @partnered_channels_items ||= partnered_channels_response(parts).body['items']
          @partnered_channels_items.each do |item|
            channels << Yt::Channel.new(item.symbolize_keys.slice(*parts))
          end
        end
      end

    private

    ### OVERVIEW

      def overview_response
        Net::HTTP.start 'www.googleapis.com', 443, use_ssl: true do |http|
          http.request overview_request
        end.tap{|response| response.body = JSON response.body}
      end

      def overview_request
        query = {onBehalfOfContentOwner: @id, id: @id}.to_param

        Net::HTTP::Get.new("/youtube/partner/v1/contentOwners?#{query}").tap do |request|
          request.initialize_http_header 'Content-Type' => 'application/json'
          request.add_field 'Authorization', "Bearer #{access_token}"
        end
      end

    ### ASSOCIATIONS

      def partnered_channels_response(parts)
        Net::HTTP.start 'www.googleapis.com', 443, use_ssl: true do |http|
          http.request partnered_channels_request(parts)
        end.tap{|response| response.body = JSON response.body}
      end

      def partnered_channels_request(parts)
        part = parts.join ','
        query = {managedByMe: true, onBehalfOfContentOwner: @id, part: part}.to_param

        Net::HTTP::Get.new("/youtube/v3/channels?#{query}").tap do |request|
          request.initialize_http_header 'Content-Type' => 'application/json'
          request.add_field 'Authorization', "Bearer #{access_token}"
        end
      end
    end
  end
end
