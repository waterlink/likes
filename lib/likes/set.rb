module Likes
  # Job: Understands patterns in people likings
  class Set
    # Creates new instance of Set
    #
    # @param [Array<Like>] likes List of likes
    def initialize(likes)
      @likes = likes
      build_likes_of
      build_liked
    end

    # Provides list of recommendations for person based on this
    # likeset
    #
    # Should handle amount of distinct persons <= 10**6 and amount of
    # distinct items <= 10**6, but likeset length is <= 10**7, ie it
    # is advised to use only recent likes (couple of weeks or month)
    #
    # Worst approximation of execution time:
    #
    # Given K = how much likes target person has, in reasonable
    #   situations it is not very big number
    #
    # Given N = how much distinct persons we have
    #
    # Complexity: O(NK)
    #
    # @param [Person#==] person The person to provide recommendations
    #   for
    # @return [Array<Item>] List of recommendations for the person
    def recommendations_for(person)
      Recommendations.new(person, likes_of, liked).solve
    end

    private

    attr_accessor :likes, :likes_of, :liked

    def build_likes_of
      @likes_of = {}
      likes.each do |like|
        like.add_item_to_map(likes_of)
      end
    end

    def build_liked
      @liked = {}
      likes.each do |like|
        like.add_person_to_map(liked)
      end
    end

    # @private
    # Job: Understands which items could be recommended
    class Recommendations
      def initialize(person, likes_of, liked)
        @intersections = Intersections.new(person)
        @likes_of = likes_of
        @liked = liked
        @its_likes = likes_of.fetch(person)
        add_similar_tastes
      end

      def solve
        solution_candidate(intersections.next_candidates)
      end

      private

      attr_reader :intersections, :likes_of, :liked, :its_likes

      def solution_candidate(candidates)
        return [] if candidates.empty?
        non_empty_solution(_solution_candidate(candidates))
      end

      def _solution_candidate(candidates)
        candidates.map { |other_person, _|
          likes_of.fetch(other_person) - its_likes
        }.flatten.uniq
      end

      def non_empty_solution(solution)
        return solve if solution.empty?
        solution
      end

      def add_similar_tastes
        its_likes.each do |item|
          intersections.add_similar_tastes(liked.fetch(item))
        end
      end
    end

    # @private
    # Job: Understands similar tastes
    class Intersections
      NO_LIMIT = Object.new.freeze

      def initialize(person)
        @sizes = {}
        @person = person
        @best_size = NO_LIMIT
      end

      def add_similar_tastes(people)
        people.each do |other_person|
          next if person == other_person
          sizes[other_person] = sizes.fetch(other_person, 0) + 1
        end
      end

      def next_candidates
        candidates_with(next_best_size)
      end

      private

      attr_reader :sizes, :person

      def candidates_with(intersection_size)
        return [] if no_limit?(intersection_size)
        sizes.select { |_, size| intersection_size == size }
      end

      def next_best_size
        @best_size = get_best_size(@best_size)
      end

      def get_best_size(limit)
        sizes
          .select { |_, size| in_limit?(size, limit) }
          .map { |_, size| size }.max || NO_LIMIT
      end

      def in_limit?(size, limit)
        return true if no_limit?(limit)
        size < limit
      end

      def no_limit?(limit)
        NO_LIMIT == limit
      end
    end
  end
end
