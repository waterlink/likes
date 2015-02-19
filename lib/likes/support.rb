PrimeFactory = if RUBY_VERSION.to_f > 1.8
  require "prime"
  Prime
else
  require "mathn"
  Prime.new
end

module Likes
  module Support
    # @private
    # Job: Understands float comparision in computer world
    class FloatWithError
      ALLOWED_ERROR = 1e-9

      def self.lift(value)
        return value if FloatWithError === value
        FloatWithError.new(value)
      end

      def initialize(value)
        @value = value
      end

      def ==(other)
        (self.value - FloatWithError.lift(other).value).abs < ALLOWED_ERROR
      end

      protected

      attr_accessor :value
    end

    # @private
    # Job: Understands random hash function generation
    class HashFunction
      PRIMES = PrimeFactory.first(3200)[-250..-1]

      def self.sample(count, modulo)
        (0...count).map { new(*(sample_primes(2) + [modulo])) }
      end

      def initialize(factor, constant, modulo)
        @factor, @constant, @modulo = factor, constant, modulo
      end

      def call(value)
        (factor * value + constant) % modulo
      end

      def map(values)
        values.map { |value| call(value) }
      end

      private

      attr_accessor :factor, :constant, :modulo

      def self.sample_primes(count)
        if RUBY_VERSION.to_f > 1.8
          PRIMES.sample(count)
        else
          (0...count).map { PRIMES.choice }
        end
      end
    end
  end
end
