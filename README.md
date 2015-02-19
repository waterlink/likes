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

## Contributing

1. Fork it ( https://github.com/waterlink/likes/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
