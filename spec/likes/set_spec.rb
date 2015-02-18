module Likes
  RSpec.describe Set do
    let(:likeset) {
      Likes::Set.new([
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
    }

    describe "#recommendations_for" do
      it "returns a list of items" do
        expect(likeset.recommendations_for(1)).to be_a(Array)
      end

      it "returns right recommendations" do
        expect(likeset.recommendations_for(1).sort).to eq([3])
        expect(likeset.recommendations_for(2).sort).to eq([2, 7, 9])
        expect(likeset.recommendations_for(3).sort).to eq([1])
      end

      context "when there is an identic match with other person" do
        let(:likeset) {
          Likes::Set.new([
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
          ])
        }

        it "ignores identical candidates" do
          expect(likeset.recommendations_for(1).sort).to eq([3])
        end
      end

      context "when there is nothing to recommend" do
        let(:likeset) {
          Likes::Set.new([
            Likes::Like.new(person: 1, item: 1),
            Likes::Like.new(person: 1, item: 5),
            Likes::Like.new(person: 1, item: 4),
            Likes::Like.new(person: 1, item: 7),

            Likes::Like.new(person: 4, item: 1),
            Likes::Like.new(person: 4, item: 5),
            Likes::Like.new(person: 4, item: 7),
          ])
        }

        it "returns an empty solution" do
          expect(likeset.recommendations_for(1).sort).to eq([])
        end
      end
    end
  end
end
