module Yt
  module Models
    # Provides methods to interact with YouTube channels.
    # @see https://developers.google.com/youtube/v3/docs/channels
    class Channel
      # @param [Hash] options the options to initialize a Channel.
      # @option options [String] :id The unique ID of a YouTube channel.
      def initialize(options = {})
        @id = options[:id]
      end

      # @return [String] the channel’s title.
      def title
        snippet['title']
      end

      # @return [String] the channel’s description.
      def description
        snippet['description']
      end

    private

      def snippet
        @snippet ||= response.body['items'].first['snippet']
      end

      def response
        Net::HTTP.start 'www.googleapis.com', 443, use_ssl: true do |http|
          http.request request
        end.tap{|response| response.body = JSON response.body}
      end

      def request
        query = {key: ENV['YT_API_KEY'], id: @id, part: 'snippet'}.to_param

        Net::HTTP::Get.new("/youtube/v3/channels?#{query}").tap do |request|
          request.initialize_http_header 'Content-Type' => 'application/json'
        end
      end
    end
  end
end
