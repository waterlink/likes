# Likes

[![Build Status](https://travis-ci.org/waterlink/likes.svg?branch=master)](https://travis-ci.org/waterlink/likes)

Give it a list of people and their likings and it will tell what else could these people like.

This is a ruby gem.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'likes'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install likes

## Usage

```ruby
require "likes"

likeset = Likes::Set.new([
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
])

likeset.recommendations_for(1)     #=> [3]
likeset.recommendations_for(2)     #=> [7, 2, 9]
likeset.recommendations_for(3)     #=> [1]
```

### Engines

There are currently 3 different engines:

- `Likes::Engines::BestIntersectionSize` - simplest implementation, calculates liking intersection size for current person with all other people. Chooses maximum intersection size to generate recommendations. Worst complexity: `O(NK) * O(log N + log P)` where `N` - distinct people count, `P` - distinct items count, `K` - how much likes current person has (in practice not very big number, in theory can be as high as `P`).
- `Likes::Engines::BestRelativeIntersectionSize` - the same as previous, but uses relative intersection size to eliminate 'I-like-everything-in-the-world' noise. `Relative intersection size = intersection size / (union size + intersection size)`. Worst complexity is the same as above.
- `Likes::Engines::FastJaccardSimilarity` - much faster implementation. Uses relative intersection size estimation to find people to make a base for recommendations. Uses `minhash` algorithm to calculate set signature for each person, which makes initial dataset much smaller. Allows to reuse for different people without re-calculating set signatures, but currently not implemented. Worst complexity: `D * O(P + N) * O(log N + log P)` where `D` - depth of implementation (count of different hash functions used), currently `D = 200`.

By default `FastJaccardSimilarity` is used. If you want to use different engine, then you can do this:

```ruby
Likes::Set.new(like_list, Likes::Engines::BestRelativeIntersectionSize)
```

#### Implementing your own engine

If you want to implement your own engine, you should look at this protocol: [lib/likes/engines/protocol.rb](blob/master/lib/likes/engines/protocol.rb)

## Contributing

1. Fork it ( https://github.com/waterlink/likes/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
