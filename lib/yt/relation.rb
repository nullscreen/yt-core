module Yt
  # Provides methods to iterate through collections of YouTube resources.
  # Extends the Ruby core Enumerator class with methods like +.select+ to
  # specify which parts of a YouTube resource to fetch.
  class Relation < Enumerator
    # @see http://ruby-doc.org/core-2.3.1/Enumerator.html#method-c-new
    def initialize(size = nil, &block)
      @options = {}
      super
    end

    # Specifies which parts of the resource to fetch when hitting the data API.
    # @param [Array<Symbol, String>] parts The parts to fetch.
    # @return [Yt::Relation] itself.
    def select(*parts)
      @options.merge! parts: parts
      self
    end

    # Specifies how many items to fetch when hitting the data API.
    # @param [Integer] max_results The maximum number of items to fetch.
    # @return [Yt::Relation] itself.
    def limit(max_results)
      @options.merge! limit: max_results
      self
    end

    # @see http://ruby-doc.org/core-2.3.1/Enumerator.html#method-i-each
    def each
      super @options
    end

    # @return [String] a representation of the Yt::Relation instance.
    def inspect
      entries = take(3).map!(&:inspect)
      entries[2] = '...' if entries.size == 3

      "#<#{self.class.name} [#{entries.join(', ')}]>"
    end
  end
end
