module Likes
  # Job: Understands patterns in people likings
  class Set
    # Default engine - simplest one
    #
    # @see Engines::BestIntersectionSize
    DEFAULT_ENGINE = Engines::BestIntersectionSize

    # Creates new instance of Set
    #
    # @param [Array<Like>] likes List of likes
    # @param [Engines::Protocol] engine Recommendation engine to use
    #
    # @see Engines
    def initialize(likes, engine=DEFAULT_ENGINE)
      @likes = likes
      @engine = engine
      build_likes_of
      build_liked
    end

    # Provides list of recommendations for person based on this
    # likeset
    #
    # Should handle amount of distinct people <= 10**6 and amount of
    # distinct items <= 10**6, but likeset length is <= 10**7, ie it
    # is advised to use only recent likes (couple of weeks or month)
    #
    # @param [Person#==] person The person to provide recommendations
    #   for
    # @return [Array<Item>] List of recommendations for the person
    def recommendations_for(person)
      engine.new(person, likes_of, liked).solve
    end

    private

    attr_accessor :likes, :engine, :likes_of, :liked

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
  end
end
