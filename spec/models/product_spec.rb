require 'rails_helper'

describe Product do
  describe "factory" do
    it "has a valid factory" do
      expect(FG.create(:product)).to be_valid
    end
  end

  describe "#currently_discounted" do
    let!(:product_1) do
      FG.create(:product, base_price: 2.0, current_price: 1.0)
    end

    let!(:product_2) do
      FG.create(:product, base_price: 3.0, current_price: 2.0)
    end

    let!(:product_3) do
      FG.create(:product, base_price: 1.0, current_price: 1.0)
    end

    it "returns discounted products" do
      result = Product.currently_discounted.pluck(:id)
      expect(result).to eq([product_1.id, product_2.id])
    end
  end
end
