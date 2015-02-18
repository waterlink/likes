# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'likes/version'

Gem::Specification.new do |spec|
  spec.name          = "likes"
  spec.version       = Likes::VERSION
  spec.authors       = ["Alexey Fedorov"]
  spec.email         = ["waterlink000@gmail.com"]
  spec.summary       = %q{Give it a list of people and their likings and it will tell it what else could these people like.}
  spec.description   = %q{Give it a list of people and their likings and it will tell it what else could these people like. Made for a greater good.}
  spec.homepage      = "https://github.com/waterlink/likes"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
end
