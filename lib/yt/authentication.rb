module Yt
  # Provides methods to authenticate to YouTube on behalf of a user.
  #
  # There are two different ways to use an instance of Yt::Authentication.
  # The first is to obtain the URL that users should visit to authorize a
  # web app to use YouTube on their behalf:
  #
  # @example Obtain the authorization URL:
  #   redirect_uri = 'https://example.com/auth'
  #   scopes = %w(youtube yt-analytics.readonly)
  #   auth = Yt::Authentication.new redirect_uri: redirect_uri, scopes: scopes
  #   auth.url
  #     => "https://accounts.google.com/o/oauth2/auth?access_type=..."
  #
  # The second is to obtain the OAuth tokens of a user that has authorized
  # a web app and has been redirected to the redirect_uri URL:
  #
  # @example Obtain the OAuth access and refresh token for a user:
  #   redirect_uri = 'https://example.com/auth'
  #   code = '1/34f8dfsdf8343ffd'
  #   auth = Yt::Authentication.new redirect_uri: redirect_uri, code: code
  #   auth.tokens
  #     => {access_token: "ya29.CjS...", refresh_token: "1/Flk6..."}
  #
  # Note that the refresh token is included in the response only if the user
  # is authorization the app for the first time, or whether the +force+ option
  # is set.
  #
  # @see https://developers.google.com/accounts/docs/OAuth2
  class Authentication
    # @param [Hash] options the options to authenticate.
    # @option options [String] :redirect_uri The URL where users are redirected
    #   after they authorize an app to access YouTube on their behalf.
    # @option options [Array<String, Symbol>] :scopes The permission scopes that
    #   the app needs to access on behalf of the user. Valid values are any
    #   combination of +'youtube'+, +'youtubepartner', +'youtube.readonly',
    #   +'yt-analytics.readonly'+, +'yt-analytics-monetary.readonly'+,
    #   +'userinfo.email'+, and +'userinfo.profile'+.
    # @option options [String] :code The authorization code returned as a query
    #   parameter of the redirect URI after a user has authorized the app.
    # @option options [Boolean] :force whether to fetch a new refresh token
    #   even if the user is not authorization the app for the first time.
    def initialize(options = {})
      @redirect_uri = options[:redirect_uri]
      @scopes = options[:scopes]
      @code = options[:code]
      @force = options[:force]
    end

  ### URL

    # @return [String] the URL that users can visit to authorize the app to
    #   use YouTube on their behalf for the scopes specified.
    def url
      host = 'accounts.google.com'
      path = '/o/oauth2/auth'
      query = url_params.to_param
      URI::HTTPS.build(host: host, path: path, query: query).to_s
    end

  ### TOKENS

    # @return [Hash<Symbol, String>] the OAuth2 tokens to use YouTube on behalf
    #   of a user. Note that the +:access_token:+ is always included in the
    #   response, while the +:refresh_token:+ is only included if the user is
    #   authorizing the app for the first time or if the +force+ option is set.
    def tokens
      tokens_response.body.symbolize_keys.slice(:access_token, :refresh_token)
    end

  private

  ### URL

    def url_params
      {}.tap do |params|
        params[:client_id] = Yt.configuration.client_id
        params[:scope] = authentication_scope
        params[:redirect_uri] = @redirect_uri
        params[:response_type] = :code
        params[:access_type] = :offline
        params[:approval_prompt] = @force ? :force : :auto
        # params[:include_granted_scopes] = true
      end
    end

    def authentication_scope
      @scopes.map do |scope|
        "https://www.googleapis.com/auth/#{scope}"
      end.join(' ') if @scopes.is_a?(Array)
    end

  ### TOKENS

    def tokens_response
      Net::HTTP.start 'accounts.google.com', 443, use_ssl: true do |http|
        http.request tokens_request
      end.tap{|response| response.body = JSON response.body}
    end

    def tokens_request
      Net::HTTP::Post.new("/o/oauth2/token").tap do |request|
        request.set_form_data client_id: Yt.configuration.client_id, client_secret: Yt.configuration.client_secret, code: @code, grant_type: :authorization_code, redirect_uri: @redirect_uri
        request.initialize_http_header 'Content-Type' => 'application/x-www-form-urlencoded'
      end
    end
  end
end
