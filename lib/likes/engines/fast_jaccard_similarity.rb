require "prime"

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
    class FastJaccardSimilarity

      MAX_HASH_FUNCTIONS_COUNT = 200
      PRIMES = Prime.first(3200)[-250..-1]
      ALLOW_FLUCTUATION = 0.2

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
        build_hash_functions
        init_signature
        compute_hashes
        compute_signature

        own_column = nil
        people.each_with_index do |other_person, column|
          own_column = column if person == other_person
        end

        similarities = { person => -1 }
        people.each_with_index do |other_person, column|
          next if person == other_person
          similarity = 0
          signature.each_with_index do |signature_row, index|
            similarity += 1 if signature_row[column] == signature_row[own_column]
          end
          similarities[other_person] = 1.0 * similarity / (likes_of.fetch(person).count + likes_of.fetch(other_person).count)
        end

        best_similarity = similarities.values.max
        candidates = similarities.select { |_, similarity|
          best_similarity <= similarity + ALLOW_FLUCTUATION
        }.keys

        candidates.map { |other_person, _|
          likes_of.fetch(other_person) - likes_of.fetch(person)
        }.flatten.uniq
      end

      private

      attr_reader :person, :likes_of, :liked, :items, :people,
        :signature, :hash_functions, :hashes

      def init_signature
        @signature = (0...hash_functions_count).map {
          Array.new(people.count, Float::INFINITY)
        }
      end

      # Full complexity: D * O(likeset size * log N) ~ O(N log N) with big constant
      def compute_signature
        each_like(&method(:signature_step))
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
      def signature_step(item, person, row, column)
        signature.each_with_index do |signature_row, index|
          signature_row[column] = [signature_row[column], hashes[index][row]].min
        end
      end

      def compute_hashes
        @hashes = hash_functions.map { |function|
          (0...items.count).map(&function)
        }
      end

      def build_hash_functions
        modulo = items.count
        @hash_functions = (0...hash_functions_count).map {
          factor, constant = PRIMES.sample(2)
          hash_function(factor, constant, modulo)
        }
      end

      def hash_function(factor, constant, modulo)
        Proc.new { |value| (factor * value + constant) % modulo }
      end

      def hash_functions_count
        MAX_HASH_FUNCTIONS_COUNT
      end
    end
  end
end
