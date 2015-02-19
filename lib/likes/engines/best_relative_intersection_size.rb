require "likes/engines/best_intersection_size"

module Likes
  module Engines
    # Job: Understands which items could be recommended
    #
    # Calculates relative intersection sizes to all other person
    # likings and chooses maximum. This is Jaccard Similarity of Sets
    # algorithm implementation
    #
    # Relative intersection size = intersection size / union size
    #
    # Worst approximation of execution time:
    #
    # Given K = how much likes target person has, in reasonable
    # situations it is not very big number. But in theory can be as
    # high as P
    #
    # Given P = how much distinct items we have
    #
    # Given N = how much distinct people we have
    #
    # Complexity: O(NK) * O(hash operations ~ log N + log P)
    #
    # @see BestIntersectionSize
    class BestRelativeIntersectionSize

      # Creates new instance of BestRelativeIntersectionSize engine
      #
      # @param [Person#==] person The person to provide
      #   recommendations for
      # @param [Hash<Person, Array<Item>>] likes_of Input data in form
      #   of map person => [item]
      # @param [Hash<Item, Array<Person>>] liked Input data in form of
      #   map item => [person]
      def initialize(person, likes_of, liked)
        @delegatee = BestIntersectionSize.new(
          person,
          likes_of,
          liked,
          RelativeIntersectionsFactory.new(likes_of),
        )
      end

      # Solves the problem and returns recommendation list
      #
      # @return [Array<Item>] Returns list of recommended items
      def solve
        delegatee.solve
      end

      private

      attr_reader :delegatee

      # @private
      # Job: Understands how needs of Intersections with relative
      # logic
      class RelativeIntersectionsFactory
        def initialize(likes_of)
          @sets_sizes = likes_of.map { |person, items| [person, items.size] }.to_h
        end

        def build(person)
          BestIntersectionSize::Intersections.new(person, size_transform(person))
        end

        private

        attr_reader :sets_sizes

        def size_transform(person)
          RelativeSizeTransform.new(person, sets_sizes)
        end
      end

      # @private
      # Job: Understands conversion between absolute and relative
      # intersection sizes
      class RelativeSizeTransform
        def initialize(person, sets_sizes)
          @person = person
          @sets_sizes = sets_sizes
        end

        def call(other_person, intersection_size)
          1.0 * intersection_size / union_size(other_person)
        end

        alias_method :[], :call

        private

        attr_reader :person, :sets_sizes

        def union_size(other_person)
          sets_sizes[other_person] + own_size
        end

        def own_size
          @_own_size ||= sets_sizes[person]
        end
      end
    end
  end
end
