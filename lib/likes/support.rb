require "prime"

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
      PRIMES = Prime.first(3200)[-250..-1]

      def self.sample(count, modulo)
        (0...count).map { new(*(PRIMES.sample(2) + [modulo])) }
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
    end
  end
end
