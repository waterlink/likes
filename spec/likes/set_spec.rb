module Likes
  RSpec.describe Set do
    let(:engine) { class_double(Engines::Protocol) }
    let(:engine_instance) { instance_double(Engines::Protocol) }

    let(:raw_likeset) { Fixtures.small_likeset }
    let(:likeset) { Set.new(raw_likeset, engine) }

    let(:proper_likes_of) { Fixtures.small_likeset_likes_of }
    let(:proper_liked) { Fixtures.small_likeset_liked }

    describe "#recommendations_for" do
      let(:person) { double("Person") }
      let(:solution) { double("Solution") }

      it "builds proper likes_of and liked and delegates solution to engine instance" do
        expect(engine).
          to receive(:new).
          with(person, proper_likes_of, proper_liked).
          and_return(engine_instance)

        expect(engine_instance).to receive(:solve).and_return(solution)

        expect(likeset.recommendations_for(person)).to eq(solution)
      end
    end
  end
end
