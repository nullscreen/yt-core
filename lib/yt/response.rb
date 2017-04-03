module Yt
  # @private
  class Response
    def initialize(options, &block)
      @options = options
      @block = block
    end

    def run
      instance_exec @options, &@block
    end

  private

    def fetch(path, params)
      HTTPRequest.new(path: path, params: params).run
    end

    def resources_path
      @options[:item_class].name.split('::').last.gsub(/^(\w{1})(.*)/) do
        "/youtube/v3/#{$1.downcase}#{$2}s"
      end
    end

    def where_params(options)
      ids = options[:conditions].fetch(:id, []).join ','
      default_params(options).merge id: ids
    end

    def channel_playlists_params(options)
      default_params(options).merge channel_id: options[:channel_id]
    end

    def channel_videos_params(options)
      params = {channel_id: options[:channel_id], order: :date, type: :video}
      default_params(options.merge parts: %i(id)).merge params
    end

    def playlist_items_params(options)
      default_params(options).merge playlist_id: options[:playlist_id]
    end

    def resource_params(options)
      default_params(options).merge id: options[:ids].join(',')
    end

    def default_params(options)
      {}.tap do |params|
        params[:max_results] = 50
        params[:key] = Yt.configuration.api_key
        params[:part] = options[:parts].join ','
        params[:page_token] = options[:offset]
      end
    end

    def slicing_conditions_every(size, &block)
      slices = @options[:conditions].fetch(:id, []).each_slice size
      slices.inject(nil) do |response, ids|
        slice_options = @options.merge conditions: {id: ids}
        response = combine_slices response, yield(slice_options)
      end
    end

    def combine_slices(total, partial)
      if total
        total.body['items'] += partial.body['items']
        total_results = partial.body['pageInfo']['totalResults']
        total.body['pageInfo']['totalResults'] += total_results
        total
      else
        partial
      end
    end

    # Expands the resultset into a collection of videos by fetching missing
    # parts, eventually with an additional HTTP request.
    def videos_for(items, key, options)
      items.body['items'].map{|item| item['id'] = item[key]['videoId']}

      if options[:parts] == %i(id)
        items
      else
        options[:ids] = items.body['items'].map{|item| item['id']}
        options[:offset] = nil
        fetch('/youtube/v3/videos', resource_params(options)).tap do |response|
          response.body['nextPageToken'] = items.body['nextPageToken']
        end
      end
    end
  end
end
