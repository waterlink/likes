module Likes
  # Job: Understands relation between person and the item they like
  class Like
    # Creates new instance of Like
    #
    # @param [Hash] attributes The attributes to create Like instance with
    # @option attributes [Person#==] :person The person under the question. Required
    # @option attributes [Item#==] :item The item person like. Required
    def initialize(attributes={})
      @person = fetch_required_attribute(attributes, :person)
      @item = fetch_required_attribute(attributes, :item)
    end

    # Tests other object for equality with itself. Objects of type
    # different from Like are considered non-equal.
    #
    # @param [Any, Like] other Other object to test for equality
    # @return [TrueClass, FalseClass] Returns true if objects are
    #   equal, false otherwise
    def ==(other)
      return false unless Like === other
      self.person == other.person &&
        self.item == other.item
    end

    # @private
    def add_item_to_map(map)
      (map[person] ||= []) << item
    end

    # @private
    def add_person_to_map(map)
      (map[item] ||= []) << person
    end

    protected

    attr_reader :person, :item

    private

    def fetch_required_attribute(attributes, name)
      attributes.fetch(name) { raise ArgumentError.new("Attribute #{name} is required") }
    end
  end
end
