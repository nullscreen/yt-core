module Yt
  # Provides methods to authenticate as a YouTube account.
  # @see https://developers.google.com/youtube/v3/guides/authentication
  class Account
    # @param [Hash] options the options to initialize an Account.
    # @option options [String] :refresh_token The refresh token to interact
    #   with the YouTube API on behalf of a YouTube account.
    def initialize(options = {})
      @access_token = options[:access_token]
      @refresh_token = options[:refresh_token]
    end

  ### AUTHENTICATION

    # @return [String] the OAuth2 Google access token.
    def access_token
      @access_token ||= access_token_response.body['access_token']
    end

  ### USER INFO

    # @return [String] the unique Google account id.
    def id
      user_info_response.body['id']
    end

    # @return [String] the email associated with the Google account.
    def email
      user_info_response.body['email']
    end

    # @return [Boolean] whether the email has been verified with Google.
    def verified_email
      user_info_response.body['verified_email']
    end

    # @return [String] the full name associated with the Google account.
    def name
      user_info_response.body['name']
    end

    # @return [String] the given name associated with the Google account.
    def given_name
      user_info_response.body['given_name']
    end

    # @return [String] the family name associated with the Google account.
    def family_name
      user_info_response.body['family_name']
    end

    # @return [String] the URL of the avatar associated with the Google account.
    def avatar_url
      user_info_response.body['picture']
    end

    # @return [String] the default locale for the Google account.
    def locale
      user_info_response.body['locale']
    end

    # @return [String] the name of the Google Apps domain the account belongs to.
    def hd
      user_info_response.body['hd']
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

  ### USER INFO

    def user_info_response
      @user_info_response ||= Net::HTTP.start 'www.googleapis.com', 443, use_ssl: true do |http|
        http.request user_info_request
      end.tap{|response| response.body = JSON response.body}
    end

    def user_info_request
      Net::HTTP::Get.new("/oauth2/v2/userinfo").tap do |request|
        request.initialize_http_header 'Content-Type' => 'application/json'
        request.add_field 'Authorization', "Bearer #{access_token}"
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