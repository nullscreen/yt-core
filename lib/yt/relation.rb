module Yt
  # @private
  class Relation < Enumerator
    def initialize(size = nil, &block)
      @options = {}
      super
    end
    # Specifies which parts of the channel to fetch when hitting the data API.
    # @param [Array<Symbol, String>] parts The parts to fetch.
    # @return [Yt::Relation] itself.
    def select(*parts)
      @options.merge! parts: parts
      self
    end

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
