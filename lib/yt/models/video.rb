module Yt
  module Models
    # Provides methods to interact with YouTube videos.
    # @see https://developers.google.com/youtube/v3/docs/videos
    class Video
      # @param [Hash] options the options to initialize a Channel.
      # @option options [String] :id The unique ID of a YouTube channel.
      def initialize(options = {})
        @id = options[:id]
        @auth = options[:auth]
        @data = HashWithIndifferentAccess.new
        @data[:snippet] = options[:snippet] if options[:snippet]
      end

    ### SNIPPET

      # @return [Time] the date and time that the channel was created.
      def published_at
        Time.parse snippet['publishedAt']
      end

      # @return [String] the ID of the video’s channel.
      def channel_id
        snippet['channelId']
      end

      # @return [String] the video’s title.
      def title
        snippet['title']
      end

      # @return [String] the channel’s description.
      def description
        snippet['description']
      end

      # Returns the URL of the video’s thumbnail.
      # @param [Symbol, String] size The size of the video’s thumbnail.
      # @return [String] if +size+ is +:default+, the URL of a 120x90px image.
      # @return [String] if +size+ is +:medium+, the URL of a 320x180px image.
      # @return [String] if +size+ is +:high+, the URL of a 480x360px image.
      # @return [String] if +size+ is +:standard+, the URL of a 640x480px image.
      # @return [String] if +size+ is +:maxres+, the URL of a 1280x720px image.
      # @return [nil] if the +size+ is none of the above.
      def thumbnail_url(size = :default)
        snippet['thumbnails'].fetch(size.to_s, {})['url']
      end

      # @return [String] the title of the video’s channel.
      def channel_title
        snippet['channelTitle']
      end

      # @return [Array] the list of the video’s tags.
      def tags
        snippet['tags']
      end

      # @return [Integer] the ID of the video’s category.
      def category_id
        snippet['categoryId'].to_i
      end

      # @return [String] whether the video is an upcoming/active live broadcast.
      #   Valid values are: +live+, +none+, +upcoming+.
      def live_broadcast_content
        snippet['liveBroadcastContent']
      end

      # def default_language # not yet implemented, not sure how to set to test

      # def localized # not yet implemented

      # def default_audio_language # not yet implemented, not sure how to set to test

    ### OTHERS

      # @return [String] a representation of the Yt::Video instance.
      def inspect
        "#<#{self.class} @id=#{@id}>"
      end

    private

    ### DATA

      def snippet
        data_part 'snippet'
      end

      def data_part(part)
        @data[part] || fetch_data(part)
      end

      def fetch_data(part)
        parts = @selected_data_parts || [part]
        if (items = data_response(parts).body['items']).any?
          parts.each{|part| @data[part] = items.first[part.to_s]}
          @data[part]
        else
          raise Errors::NoItems
        end
      end

      def data_response(parts)
        Net::HTTP.start 'www.googleapis.com', 443, use_ssl: true do |http|
          http.request data_request(parts)
        end.tap{|response| response.body = JSON response.body}
      end

      def data_request(parts)
        part = parts.join ','
        query = {key: ENV['YT_API_KEY'], id: @id, part: part}.to_param

        Net::HTTP::Get.new("/youtube/v3/videos?#{query}").tap do |request|
          request.initialize_http_header 'Content-Type' => 'application/json'
        end
      end
    end
  end
end
