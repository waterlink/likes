module Fixtures
  class << self
    def small_likeset
      [
        Likes::Like.new(person: 1, item: 5),

        Likes::Like.new(person: 3, item: 5),
        Likes::Like.new(person: 3, item: 4),
      ]
    end

    def small_likeset_likes_of
      {
        1 => [5],
        3 => [5, 4],
      }
    end

    def small_likeset_liked
      {
        5 => [1, 3],
        4 => [3],
      }
    end

    def regular_likeset
      [
        Likes::Like.new(person: 1, item: 1),
        Likes::Like.new(person: 1, item: 5),
        Likes::Like.new(person: 1, item: 4),
        Likes::Like.new(person: 1, item: 7),

        Likes::Like.new(person: 2, item: 1),
        Likes::Like.new(person: 2, item: 3),
        Likes::Like.new(person: 2, item: 5),
        Likes::Like.new(person: 2, item: 4),

        Likes::Like.new(person: 3, item: 3),
        Likes::Like.new(person: 3, item: 2),
        Likes::Like.new(person: 3, item: 5),
        Likes::Like.new(person: 3, item: 4),
        Likes::Like.new(person: 3, item: 9),
      ]
    end

    def best_intersection_candidate_has_no_other_likings
      [
        Likes::Like.new(person: 1, item: 1),
        Likes::Like.new(person: 1, item: 5),
        Likes::Like.new(person: 1, item: 4),
        Likes::Like.new(person: 1, item: 7),

        Likes::Like.new(person: 2, item: 1),
        Likes::Like.new(person: 2, item: 3),
        Likes::Like.new(person: 2, item: 5),
        Likes::Like.new(person: 2, item: 4),

        Likes::Like.new(person: 4, item: 1),
        Likes::Like.new(person: 4, item: 5),
        Likes::Like.new(person: 4, item: 4),
        Likes::Like.new(person: 4, item: 7),

        Likes::Like.new(person: 3, item: 3),
        Likes::Like.new(person: 3, item: 2),
        Likes::Like.new(person: 3, item: 5),
        Likes::Like.new(person: 3, item: 4),
        Likes::Like.new(person: 3, item: 9),
      ]
    end

    def there_is_nothing_to_recommend
      [
        Likes::Like.new(person: 1, item: 1),
        Likes::Like.new(person: 1, item: 5),
        Likes::Like.new(person: 1, item: 4),
        Likes::Like.new(person: 1, item: 7),

        Likes::Like.new(person: 4, item: 1),
        Likes::Like.new(person: 4, item: 5),
        Likes::Like.new(person: 4, item: 7),
      ]
    end
  end
end
