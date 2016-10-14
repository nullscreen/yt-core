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

      # @return [String] the OAuth2 Google access token.
      def access_token
        access_token_response.body['access_token']
      end

    private

      def access_token_response
        Net::HTTP.start 'accounts.google.com', 443, use_ssl: true do |http|
          http.request access_token_request
        end.tap{|response| response.body = JSON response.body}
      end

      def access_token_request
        Net::HTTP::Post.new("/o/oauth2/token").tap do |request|
          request.set_form_data client_id: ENV['YT_CLIENT_ID'], client_secret: ENV['YT_CLIENT_SECRET'], refresh_token: @refresh_token, grant_type: 'refresh_token'
          request.initialize_http_header 'Content-Type' => 'application/x-www-form-urlencoded'
        end
      end
    end
  end
end
