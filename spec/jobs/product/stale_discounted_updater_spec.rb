require 'rails_helper'
describe Product::StaleDiscountedUpdater do
  describe "perform" do
    let(:product) do
      FG.create(:product,
        base_price: 3.99,
        current_price: 2.99,
        current_price_formatted: "2.99$",
      )
    end

    subject do
      Product::StaleDiscountedUpdater.new(api_client).perform(product.id)
    end

    context "products price did increase" do
      let(:api_client) do
        double(
          get_data: {
            current_price: 3.99,
            current_price_formatted: "3.99$"
          }
        )
      end

      it "updates the current price" do
        expect(product.is_discounted?).to eq true
        subject
        product.reload
        expect(product.current_price).to eq 3.99
        expect(product.current_price_formatted).to eq "3.99$"
        expect(product.is_discounted?).to eq false
      end
    end

    context "products price did not increase" do
      let(:api_client) do
        double(
          get_data: {
            current_price: 1.99,
            current_price_formatted: "1.99$"
          }
        )
      end

      it "does nothing" do
        expect(product.is_discounted?).to eq true
        subject
        product.reload
        expect(product.current_price).to eq 2.99
        expect(product.current_price_formatted).to eq "2.99$"
        expect(product.is_discounted?).to eq true
      end
    end
  end
end
