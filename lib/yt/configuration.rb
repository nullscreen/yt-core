module Yt
  # Provides an object to store global configuration settings.
  #
  # This class is typically not used directly, but by calling
  # {Yt::Config#configure Yt.configure}, which creates and updates a single
  # instance of {Yt::Configuration}.
  class Configuration
    # @return [String] the Client ID for web/device YouTube applications.
    # @see https://console.developers.google.com Google Developers Console
    attr_accessor :client_id

    # @return [String] the Client Secret for web/device YouTube applications.
    # @see https://console.developers.google.com Google Developers Console
    attr_accessor :client_secret

    # @return [String] the API key for server/browser YouTube applications.
    # @see https://console.developers.google.com Google Developers Console
    attr_accessor :api_key

    # @return [String] the level of output to print for debugging purposes.
    attr_accessor :log_level

    # Initialize the global configuration settings, using the values of
    # the specified following environment variables by default.
    def initialize
      @client_id = ENV['YT_CLIENT_ID']
      @client_secret = ENV['YT_CLIENT_SECRET']
      @api_key = ENV['YT_API_KEY']
      @log_level = ENV['YT_LOG_LEVEL']
    end
  end

  # Provides methods to read and write global configuration settings.
  #
  # A typical usage is to set the API keys retrieved from the
  # {http://console.developers.google.com Google Developers Console}.
  #
  # @example Set the API key for a server-only YouTube app:
  #   Yt.configure do |config|
  #     config.api_key = 'ABCDEFGHIJ1234567890'
  #   end
  #
  # An alternative way to set global configuration settings is by storing
  # them in the following environment variables:
  #
  # * +YT_CLIENT_ID+ to store the Client ID for web/device apps
  # * +YT_CLIENT_SECRET+ to store the Client Secret for web/device apps
  # * +YT_API_KEY+ to store the API key for server/browser apps
  # * +YT_LOG_LEVEL+ to store the verbosity level of the logs
  #
  # @example Set the API key for a server-only YouTube app:
  #   ENV['API_KEY'] = 'ABCDEFGHIJ1234567890'
  #
  # In case both methods are used together,
  # {Yt::Config#configure Yt.configure} takes precedence.
  module Config
    # Yields the global configuration to the given block.
    #
    # @example
    #   Yt.configure do |config|
    #     config.api_key = 'ABCDEFGHIJ1234567890'
    #   end
    #
    # @yield [Yt::Configuration] The global configuration.
    def configure
      if block_given?
        yield configuration
      end
    end

    # Returns the global {Yt::Configuration} object.
    #
    # While this method _can_ be used to read and write configuration settings,
    # it is easier to use {Yt::Config#configure} Yt.configure}.
    #
    # @example
    #   Yt.configuration.api_key = 'ABCDEFGHIJ1234567890'
    #
    # @return [Yt::Configuration] The global configuration.
    def configuration
      @configuration ||= Yt::Configuration.new
    end
  end

  # @note Config is the only module auto-loaded in the Yt module,
  #   in order to have a syntax as easy as Yt.configure
  extend Config
end