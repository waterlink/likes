module Likes
  module Engines
    # @abstract
    # Defines protocol which any Engine should support
    class Protocol

      # @ignore :reek:UnusedParameters
      # Creates new instance of engine
      #
      # @param [Person#==] person The person to provide
      #   recommendations for
      # @param [Hash<Person, Array<Item>>] likes_of Input data in form
      #   of map person => [item]
      # @param [Hash<Item, Array<Person>>] liked Input data in form of
      #   map item => [person]
      def initialize(person, likes_of, liked)
        abstract
      end

      # Solves the problem and returns recommendation list
      #
      # @return [Array<Item>] Returns list of recommended items
      def solve
        abstract
      end

      private

      def abstract
        raise NotImplementedError.new("Likes::Engines::Protocol is abstract")
      end
    end
  end
end
