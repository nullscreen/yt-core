module Yt
  module Models
    # Provides methods to interact with YouTube channels.
    # @see https://developers.google.com/youtube/v3/docs/channels
    class Channel
      # @param [Hash] options the options to initialize a Channel.
      # @option options [String] :id The unique ID of a YouTube channel.
      def initialize(options = {})
        @id = options[:id]
        @auth = options[:auth]
      end

    ### DATA

      # @return [String] the channel’s title.
      def title
        snippet['title']
      end

      # @return [String] the channel’s description.
      def description
        snippet['description']
      end

      # Returns the URL of the channel’s thumbnail.
      # @param [Symbol, String] size The size of the channel’s thumbnail.
      # @return [String] if +size+ is +default+, the URL of a 88x88px image.
      # @return [String] if +size+ is +medium+, the URL of a 240x240px image.
      # @return [String] if +size+ is +high+, the URL of a 800x800px image.
      # @return [nil] if the +size+ is not +default+, +medium+ or +high+.
      def thumbnail_url(size = :default)
        snippet['thumbnails'].fetch(size.to_s, {})['url']
      end

      # @return [Time] the date and time that the channel was created.
      def published_at
        Time.parse snippet['publishedAt']
      end

    ### ANALYTICS

      # @return [Hash<Symbol, Integer>] the total channel’s views.
      def views
        @views ||= {total: views_response.body['rows'].first.first.to_i}
      end

      # @return [Hash<Symbol, Integer>] the total channel’s impressions.
      def ad_impressions
        @ad_impressions ||= {total: ad_impressions_response.body['rows'].first.first.to_i}
      end

    ### OTHERS

      def inspect
        "#<#{self.class} @id=#{@id}>"
      end

    private

      def snippet
        @snippet ||= if (items = snippet_response.body['items']).any?
          items.first['snippet']
        else
          raise Errors::NoItems
        end
      end

      def snippet_response
        Net::HTTP.start 'www.googleapis.com', 443, use_ssl: true do |http|
          http.request snippet_request
        end.tap{|response| response.body = JSON response.body}
      end

      def snippet_request
        query = {key: ENV['YT_API_KEY'], id: @id, part: 'snippet'}.to_param

        Net::HTTP::Get.new("/youtube/v3/channels?#{query}").tap do |request|
          request.initialize_http_header 'Content-Type' => 'application/json'
        end
      end

      def views_response
        Net::HTTP.start 'www.googleapis.com', 443, use_ssl: true do |http|
          http.request views_request
        end.tap{|response| response.body = JSON response.body}
      end


      def views_request
        query = {'metrics' => 'views', 'end-date' => Date.today.to_s, 'start-date' => '2005-02-01', 'ids' => "channel==#{@id}"}.to_param

        Net::HTTP::Get.new("/youtube/analytics/v1/reports?#{query}").tap do |request|
          request.initialize_http_header 'Content-Type' => 'application/json'
          request.add_field 'Authorization', "Bearer #{@auth.access_token}"
        end
      end

      def ad_impressions_response
        Net::HTTP.start 'www.googleapis.com', 443, use_ssl: true do |http|
          http.request ad_impressions_request
        end.tap{|response| response.body = JSON response.body}
      end


      def ad_impressions_request
        query = {'metrics' => 'adImpressions', 'end-date' => Date.today.to_s, 'start-date' => '2005-02-01', 'ids' => "contentOwner==#{@auth.id}", 'filters' => "channel==#{@id}"}.to_param

        Net::HTTP::Get.new("/youtube/analytics/v1/reports?#{query}").tap do |request|
          request.initialize_http_header 'Content-Type' => 'application/json'
          request.add_field 'Authorization', "Bearer #{@auth.access_token}"
        end
      end
    end
  end
end
