module Yt
  module Models
    # Provides methods to authenticate as a YouTube account.
    # @see https://developers.google.com/youtube/v3/guides/authentication
    class Account
      # @param [Hash] options the options to initialize an Account.
      # @option options [String] :refresh_token The refresh token to interact
      #   with the YouTube API on behalf of a YouTube account.
      def initialize(options = {})
        @refresh_token = options[:refresh_token]
      end

    ### AUTHENTICATION

      # @return [String] the OAuth2 Google access token.
      def access_token
        access_token_response.body['access_token']
      end

    ### ASSOCIATIONS

      # @return [Yt::Relation<Yt::Video>] the videos of the channel.
      def videos
        Yt::Relation.new do |videos, options = {}|
          parts = (options[:parts] || []) + [:id]
          @videos_items ||= videos_response(parts).body['items']
          @videos_items.each do |item|
            item['id'] = item['id']['videoId']
            videos << Yt::Video.new(item.symbolize_keys.slice(*parts))
          end
        end
      end

    ### OTHERS

      # @return [String] a representation of the Yt::Account instance.
      def inspect
        "#<#{self.class} @refresh_token=#{@refresh_token[0..2]}...>"
      end

    private

    ### AUTHENTICATION

      def access_token_response
        Net::HTTP.start 'accounts.google.com', 443, use_ssl: true do |http|
          http.request access_token_request
        end.tap{|response| response.body = JSON response.body}
      end

      def access_token_request
        Net::HTTP::Post.new("/o/oauth2/token").tap do |request|
          request.set_form_data client_id: Yt.configuration.client_id, client_secret: Yt.configuration.client_secret, refresh_token: @refresh_token, grant_type: 'refresh_token'
          request.initialize_http_header 'Content-Type' => 'application/x-www-form-urlencoded'
        end
      end

    ### ASSOCIATIONS

      def videos_response(parts)
        Net::HTTP.start 'www.googleapis.com', 443, use_ssl: true do |http|
          http.request videos_request(parts)
        end.tap{|response| response.body = JSON response.body}
      end

      def videos_request(parts)
        part = parts.join ','
        query = {forMine: true, type: :video, part: part}.to_param

        Net::HTTP::Get.new("/youtube/v3/search?#{query}").tap do |request|
          request.initialize_http_header 'Content-Type' => 'application/json'
          request.add_field 'Authorization', "Bearer #{access_token}"
        end
      end
    end
  end
end
