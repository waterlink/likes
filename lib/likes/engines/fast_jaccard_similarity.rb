module Likes
  module Engines
    # Job: Understands which items could be recommended
    #
    # Calculates Minhash Signatures and uses them to give approximate
    # relative intersection size. Returns recommendations from best
    # approximate relative intersection sizes
    #
    # Relative intersection size = intersection size / union size
    #
    # Worst approximation of execution time:
    #
    # Given P = how much distinct items we have
    #
    # Given N = how much distinct people we have
    #
    # Given D = depth of this implementation - maximum count of hash functions (~100)
    #
    # Complexity: O(ND + PD) * O(hash operations ~ log N + log P) ~ O(N * log N)
    # @ignore has a lot of memoization :reek:TooManyInstanceVariables
    class FastJaccardSimilarity

      MAX_HASH_FUNCTIONS_COUNT = 200
      ALLOW_FLUCTUATION = 1.075
      INFINITY = 1.0 / 0

      # Creates new instance of FastJaccardSimilarity engine
      #
      # @param [Person#==] person The person to provide
      #   recommendations for
      # @param [Hash<Person, Array<Item>>] likes_of Input data in form
      #   of map person => [item]
      # @param [Hash<Item, Array<Person>>] liked Input data in form of
      #   map item => [person]
      def initialize(person, likes_of, liked)
        @person = person
        @likes_of = likes_of
        @liked = liked
        @items = liked.keys
        @people = likes_of.keys
      end

      # Solves the problem and returns recommendation list
      #
      # @return [Array<Item>] Returns list of recommended items
      def solve
        init_signature
        compute_hashes
        compute_signature
        recommendations
      end

      private

      attr_reader :person, :likes_of, :liked, :items, :people,
        :signature, :hash_functions, :hashes

      def init_signature
        @signature = (0...MAX_HASH_FUNCTIONS_COUNT).map {
          Array.new(people.count, INFINITY)
        }
      end

      def own_column
        @_own_column ||= people.index(person)
      end

      def similarities
        @_similarities ||= people.
                         each_with_index.
                         inject({person => -1}) do |similarities, (other_person, column)|
          if person != other_person
            similarities[other_person] = relative_similarity(similarity_for(column), other_person)
          end
          similarities
        end
      end

      def similarity_for(column)
        signature.each_with_index.select { |signature_row, index|
          signature_row[column] == signature_row[own_column]
        }.count
      end

      def relative_similarity(similarity, other_person)
        1.0 * similarity / union_size(other_person)
      end

      def union_size(other_person)
        own_likes_count + likes_of.fetch(other_person).count
      end

      def own_likes
        @_own_likes ||= likes_of.fetch(person)
      end

      def own_likes_count
        @_own_likes_count ||= own_likes.count
      end

      def best_similarity
        similarities.values.max
      end

      def candidates
        Hash[similarities.select { |_, similarity|
          best_similarity <= similarity * ALLOW_FLUCTUATION
        }].keys
      end

      def recommendations
        candidates.map { |other_person, _|
          likes_of.fetch(other_person) - own_likes
        }.flatten.uniq
      end

      # Full complexity: D * O(likeset size * log N) ~ O(N log N) with big constant
      def compute_signature
        each_like do |_, _, row, column|
          signature_step(row, column)
        end
      end

      # Complexity: O(likeset size) * O(log N) ~ O(N log N)
      def each_like(&blk)
        items.each_with_index do |item, row|
          each_column_of_likes(item, row, &blk)
        end
      end

      def each_column_of_likes(item, row, &blk)
        # only columns with 1 in matrix:
        liked.fetch(item).each_with_index do |person, column|
          blk[item, person, row, column]
        end
      end

      # Complexity: D * O(1)
      def signature_step(row, column)
        signature.each_with_index do |signature_row, index|
          signature_row[column] = [signature_row[column], hashes[index][row]].min
        end
      end

      def compute_hashes
        @hashes = hash_functions.map { |function|
          function.map(0...items.count)
        }
      end

      def hash_functions
        @_hash_functions ||= Support::HashFunction.sample(
          MAX_HASH_FUNCTIONS_COUNT,
          items.count
        )
      end
    end
  end
end
