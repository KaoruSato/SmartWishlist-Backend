require 'rails_helper'

describe Discount do
  describe "relations" do
    it "has a valid factory" do
      expect(FG.create(:discount)).to be_valid
    end
  end

  let(:discount) do
    product = FG.create(:product, currency: "PLN")
    FG.create(:discount, from_price: 1, to_price: 2, product: product)
  end

  describe "update_usd_prices" do
    context "currency data available" do
      before do
        FG.create(:currency, name: "PLN", usd_rate: 2.5)
      end

      it "calculates the correct price" do
        discount.update_usd_prices

        expect(discount.from_price_usd.to_f).to eq 0.4
        expect(discount.to_price_usd.to_f).to eq 0.8
      end
    end

    context "currency data not available" do
      it "does not throw an error" do
        expect {
          discount.update_usd_prices
        }.not_to raise_error
      end
    end
  end
end
