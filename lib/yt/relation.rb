module Yt
  # Provides methods to iterate through collections of YouTube resources.
  class Relation
    include Enumerable

    # @param [Class] item_class the class of objects to initialize when
    #   iterating through a collection of YouTube resources.
    # @yield [Hash] the options to change which items to iterate through.
    def initialize(item_class, &item_block)
      @item_class = item_class
      @item_block = item_block
      @options = {parts: [:id], limit: Float::INFINITY}
    end

    # Executes +item_block+ for each item of the collection.
    def each(&block)
      if @last_options == @options
        @items.each(&block)
      else
        @count = 0
        loop do
          break if @count >= @options[:limit]

          @response = @item_block.call @options

          @items = @response.body['items'].map do |hash|
            @item_class.new(hash.transform_keys{|k| k.underscore.to_sym}.slice(*@options[:parts]))
          end

          @items.each do |video|
            @count += 1
            break if @count > @options[:limit]
            block.call video
          end

          break if @response.body['nextPageToken'].nil? || (@items.size < 50 && @options[:limit] == Float::INFINITY)
          @options[:offset] = @response.body['nextPageToken']
        end
        @last_options = @options.dup
      end
    end

    # Specifies which parts of the resource to fetch when hitting the data API.
    # @param [Array<Symbol, String>] parts The parts to fetch.
    # @return [Yt::Relation] itself.
    def select(*parts)
      @options.merge! parts: (parts + [:id])
      self
    end

    # Specifies which items to fetch when hitting the data API.
    # @param [Hash<Symbol, String>] conditions The conditions for the items.
    # @return [Yt::Relation] itself.
    def where(conditions = {})
      @options.merge! conditions: conditions
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
      entries[2] = '...' if entries.size == 3

      "#<#{self.class.name} [#{entries.join(', ')}]>"
    end
  end
end
