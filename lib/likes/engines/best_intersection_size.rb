module Likes
  module Engines
    # Job: Understands which items could be recommended
    #
    # Calculates intersection sizes to all other person likings and
    # chooses maximum
    #
    # Worst approximation of execution time:
    #
    # Given K = how much likes target person has, in reasonable
    # situations it is not very big number
    #
    # Given N = how much distinct persons we have
    #
    # Complexity: O(NK)
    #
    # @see BestRelativeIntersectionSize
    class BestIntersectionSize

      # Creates new instance of BestIntersectionSize engine
      #
      # @param [Person#==] person The person to provide
      #   recommendations for
      # @param [Hash<Person, Array<Item>>] likes_of Input data in form
      #   of map person => [item]
      # @param [Hash<Item, Array<Person>>] liked Input data in form of
      #   map item => [person]
      #
      # @param [Factory<Intersections>#new(Person)]
      #   intersections_factory Knows how to find best intersection
      #   candidates
      def initialize(person, likes_of, liked, intersections_factory=Intersections)
        @intersections = intersections_factory.build(person)
        @likes_of = likes_of
        @liked = liked
        @its_likes = likes_of.fetch(person)
        add_similar_tastes
      end

      # Solves the problem and returns recommendation list
      #
      # @return [Array<Item>] Returns list of recommended items
      def solve
        solution_candidate(intersections.next_people_with_similar_tastes)
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

      # @private
      # Job: Null object for size transformation logic
      class NullSizeTransform
        def call(_, size)
          size
        end

        alias_method :[], :call
      end

      # @private
      # Job: Understands similar tastes
      class Intersections
        NO_LIMIT = Object.new.freeze
        ALLOWED_ERROR = 1e-9

        def self.build(person)
          new(person, NullSizeTransform.new)
        end

        def initialize(person, size_transform)
          @sizes = {}
          @person = person
          @best_size = NO_LIMIT
          @size_transform = size_transform
        end

        def add_similar_tastes(people)
          people.each do |other_person|
            next if person == other_person
            sizes[other_person] = sizes.fetch(other_person, 0) + 1
          end
        end

        def next_people_with_similar_tastes
          candidates_with(next_best_size)
        end

        private

        attr_reader :sizes, :person, :best_size, :size_transform

        def candidates_with(intersection_size)
          return [] if no_limit?(intersection_size)
          transformed_sizes.select { |_, size|
            eq_with_error?(intersection_size, size)
          }
        end

        def next_best_size
          @best_size = get_best_size(best_size)
        end

        def get_best_size(limit)
          transformed_sizes
            .select { |_, size| in_limit?(size, limit) }
            .map { |_, size| size }.max || NO_LIMIT
        end

        def transformed_sizes
          @_transformed_sizes ||= sizes.map { |person, size|
            [person, size_transform[person, size]]
          }.to_h
        end

        def in_limit?(size, limit)
          return true if no_limit?(limit)
          size < limit
        end

        def no_limit?(limit)
          NO_LIMIT == limit
        end

        def eq_with_error?(a, b)
          (a - b).abs < ALLOWED_ERROR
        end
      end
    end
  end
end
