require 'rails_helper'

describe User do
  describe "factory" do
    it "has a valid factory" do
      expect(FG.create(:user)).to be_valid
    end
  end

  describe "#is_sleeping?" do
    before do
      travel_to Time.zone.local(2016, 11, 11, 1, 00, 00)
    end

    after { travel_back }

    context "correct timezone" do
      let(:user) do
        FG.create(:user, timezone: "Europe/Berlin")
      end

      it "returns true if he is sleeping" do
        expect(user.is_sleeping?).to eq true
      end
    end

    context "invalid timezone" do
      let(:user) do
        FG.create(:user, timezone: "Po południu?")
      end

      it "uses the default timezone" do
        expect(user.is_sleeping?).to eq false
      end
    end
  end
end
