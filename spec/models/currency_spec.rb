require 'rails_helper'

describe Currency do
  describe "factory" do
    it "has a valid factory" do
      expect(FG.create(:currency)).to be_valid
    end
  end

  describe "updating usd rate" do
    let!(:currency) do
      FG.create(:currency, name: "PLN")
    end

    it "updates the rate from api" do
      result = VCR.use_cassette("fixer.io-usd_rates") do
        Currency.fetch_current_usd_rates
      end

      expect(currency.reload.usd_rate.to_f).to eq 3.6033
    end
  end
end
