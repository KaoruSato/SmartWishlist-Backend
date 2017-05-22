require 'rails_helper'

describe API::PromotionsController do
  describe "#index" do
    before do
      p1 = FG.create(:product, base_price: 5.0, current_price: 2.0, currency: "USD", store_country: 'us', store_id: 1)
      p2 = FG.create(:product, base_price: 5.0, current_price: 4.5, currency: "USD", store_country: 'us', store_id: 2)
      p3 = FG.create(:product, base_price: 5.0, current_price: 4.5, currency: "USD", store_country: 'us', store_id: 2)
      FG.create(:discount, product: p1)

      FG.create(:discount, product: p2)
      FG.create(:discount, product: p2)
      FG.create(:discount, product: p2)

      FG.create(:discount, product: p3)
    end

    context "fetching data from cache" do
      before do
        $redis.set(
          Product::PROMOTIONS_CACHE_KEY,
          { products: [] }.to_json
        )
      end

      it "works" do
        get :index
        expect(response).to be_success
        expect(json_response[:products]).not_to be_nil
      end
    end
  end
end
