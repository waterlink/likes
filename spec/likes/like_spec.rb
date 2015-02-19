module Likes
  RSpec.describe Like do
    describe "creation" do
      it "can be created with person and item" do
        expect(Like.new(:person => 1, :item => 2)).to be_a(Like)
      end

      it "cannot be created without person and/or item" do
        expect { Like.new(:person => 1) }.to raise_error(ArgumentError, /item is required/)
        expect { Like.new(:item => 2) }.to raise_error(ArgumentError, /person is required/)
        expect { Like.new }.to raise_error(ArgumentError, /is required/)
      end

      it "ignores excessive attributes" do
        expect(Like.new(:person => 1, :item => 3, :hello => "world")).to eq(Like.new(:person => 1, :item => 3))
      end
    end

    describe "encapsulation" do
      it "does not allow to access its data" do
        expect { Like.new(:person => 1, :item => 2).person }.to raise_error(NoMethodError)
        expect { Like.new(:person => 1, :item => 2).person = 3 }.to raise_error(NoMethodError)

        expect { Like.new(:person => 1, :item => 2).item }.to raise_error(NoMethodError)
        expect { Like.new(:person => 1, :item => 2).item = 3 }.to raise_error(NoMethodError)
      end
    end

    describe "equality" do
      it "is equal to another like with same person and item" do
        expect(Like.new(:person => 1, :item => 2)).to eq(Like.new(:person => 1, :item => 2))
      end

      it "is not equal to another like with different person and/or item" do
        expect(Like.new(:person => 1, :item => 2)).not_to eq(Like.new(:person => 3, :item => 2))
        expect(Like.new(:person => 1, :item => 2)).not_to eq(Like.new(:person => 1, :item => 5))
        expect(Like.new(:person => 1, :item => 2)).not_to eq(Like.new(:person => 2, :item => 4))
      end

      it "is not equal to different objects" do
        expect(Like.new(:person => 1, :item => 2)).not_to eq(nil)
        expect(Like.new(:person => 1, :item => 2)).not_to eq(Object.new)
      end
    end
  end
end
