module Likes
  # Job: Understands patterns in people likings
  class Set
    # Creates new instance of Set
    #
    # @param [Array<Like>] likes List of likes
    def initialize(likes)
      @likes = likes
      build_likes_of
      build_liked_by
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
      intersection_sizes = {}
      likes_of_person = likes_of.fetch(person)
      # outer loop size: how much likes target person has. O(K)
      likes_of_person.each do |item|
        # inner loop: hom much people liked one of the items. Worst
        #   case O(N)
        liked_by.fetch(item).each do |other_person|
          next if person == other_person
          intersection_sizes[other_person] = intersection_sizes.fetch(other_person, 0) + 1
        end
      end

      best_size = intersection_sizes.map { |_, size| size }.max
      candidates = intersection_sizes.select { |_, size| best_size == size }
      candidates.map { |other_person, _|
        likes_of.fetch(other_person) - likes_of_person
      }.flatten.uniq
    end

    private

    attr_accessor :likes, :likes_of, :liked_by

    def build_likes_of
      @likes_of = {}
      likes.each do |like|
        like.add_item_to_map(likes_of)
      end
    end

    def build_liked_by
      @liked_by = {}
      likes.each do |like|
        like.add_person_to_map(liked_by)
      end
    end
  end
end
