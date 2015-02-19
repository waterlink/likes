module Likes
  RSpec.describe "Set with Likes::Engines::FastJaccardSimilarity" do
    let(:engine) { Engines::FastJaccardSimilarity }

    let(:raw_likeset) { Fixtures.regular_likeset }
    let(:likeset) { Set.new(raw_likeset, engine) }

    describe "#recommendations_for" do
      it "returns a list of items" do
        expect(likeset.recommendations_for(1)).to be_a(Array)
      end

      it "returns right recommendations" do
        expect(likeset.recommendations_for(1).sort).to eq([3])
        expect(likeset.recommendations_for(2).sort).to eq([2, 7, 9, 19]).or eq([7, 19]).or eq([2, 9])
        expect(likeset.recommendations_for(3).sort).to eq([1])
      end

      context "when somebody literally likes everything" do
        let(:raw_likeset) { Fixtures.somebody_likes_literally_everything }

        it "possibly can choose this person as a candidate for recommendations" do
          expect(likeset.recommendations_for(1).sort).to eq([4, 9]).or eq([3, 4, 6, 7, 9, 17, 19])
        end
      end

      context "when there is an identic match with other person" do
        let(:raw_likeset) { Fixtures.best_intersection_candidate_has_no_other_likings }

        it "ignores identical candidates" do
          expect(likeset.recommendations_for(1).sort).to eq([3])
        end
      end

      context "when there is nothing to recommend" do
        let(:raw_likeset) { Fixtures.there_is_nothing_to_recommend }

        it "returns an empty solution" do
          expect(likeset.recommendations_for(1).sort).to eq([])
        end
      end
    end
  end
end
