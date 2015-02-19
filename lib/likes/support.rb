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
  end
end
