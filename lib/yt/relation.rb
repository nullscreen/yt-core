module Yt
  # Provides methods to iterate through collections of YouTube resources.
  # @private
  class Relation
    include Enumerable

    # @param [Class] item_class the class of objects to initialize when
    #   iterating through a collection of YouTube resources.
    # @yield [Hash] the options to change which items to iterate through.
    def initialize(item_class, options = {}, &item_block)
      @options = {parts: %i(id), limit: Float::INFINITY, item_class: item_class,
        initial_items: -> {[]}, extract_items: -> (body) {body['items']}}
      @options.merge! options
      @item_block = item_block
    end

    # Let's start without memoizing
    def each
      @last_index = 0
      while next_item = find_next
        break if @last_index > @options[:limit]
        yield next_item
      end
    end

    def find_next
      @items ||= initial_items.dup
      if @items[@last_index].nil? && more_pages?
        response = Response.new(@options, &@item_block).run
        more_items = @options[:extract_items].call(response.body).map do |item|
          @options[:item_class].new attributes_for_new_item(item)
        end
        @options.merge! offset: response.body['nextPageToken'] if response.body
        @items.concat more_items
      end
      @items[(@last_index +=1) -1]
    end

    def more_pages?
      (@last_index == initial_items.size) || !@options[:offset].nil?
    end

    def initial_items
      @initial_items ||= @options[:initial_items].call
    end

    def attributes_for_new_item(item)
      {}.tap do |matching_parts|
        item.each_key do |key|
          part = key.gsub(/([A-Z])/) { "_#{$1.downcase}" }.to_sym
          if @options[:parts].include? part
            matching_parts[part] = item[key]
          end
        end
      end
    end

    # @return [Integer] the estimated number of items in the collection.
    def size
      size_options = @options.merge parts: %i(id), limit: 1
      @response = Response.new(size_options, &@item_block).run
      [@response.body['pageInfo']['totalResults'], @options[:limit]].min
    end

    # Specifies which parts of the resource to fetch when hitting the data API.
    # @param [Array<Symbol>] parts The parts to fetch.
    # @return [Yt::Relation] itself.
    def select(*parts)
      if @options[:parts] != parts + %i(id)
        @items = nil
        @options.merge! parts: (parts + %i(id))
      end
      self
    end

    # Specifies which items to fetch when hitting the data API.
    # @param [Hash<Symbol, String>] conditions The conditions for the items.
    # @return [Yt::Relation] itself.
    def where(conditions = {})
      if @options[:conditions] != conditions
        @items = []
        @options.merge! conditions: conditions
      end
      self
    end

    # Specifies how many items to fetch when hitting the data API.
    # @param [Integer] max_results The maximum number of items to fetch.
    # @return [Yt::Relation] itself.
    def limit(max_results)
      @options.merge! limit: max_results
      self
    end

    # @return [String] a representation of the Yt::Relation instance.
    def inspect
      entries = take(3).map!(&:inspect)
      if entries.size == 3
        entries[2] = '...'
      end

      "#<#{self.class.name} [#{entries.join(', ')}]>"
    end
  end
end
