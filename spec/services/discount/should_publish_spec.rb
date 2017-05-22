require 'rails_helper'
describe Discount::ShouldPublish do
  describe "call" do
    let(:product) do
      FG.create(
        :product,
        store_id: 'store_id_1',
        base_price: 20.0,
        current_price: 5.0,
        store_country: 'us'
      )
    end

    subject do
      Discount::ShouldPublish.call(product)
    end

    context "should tweet, not discounts tweeted yet" do
      it "returns true" do
        expect(subject).to eq true
      end
    end

    context "should not tweet" do
      before do
        FG.create(:discount, was_tweeted: true, store_id: product.store_id)
      end

      it "returns false" do
        expect(subject).to eq false
      end
    end

    context "should tweet, discount was tweeted long ago" do
      before do
        FG.create(:discount,
          was_tweeted: true,
          created_at: 2.days.ago,
          store_id: product.store_id
        )
      end

      it "returns true" do
        expect(subject).to eq true
      end
    end

    context "should not tweet if disocunt is low" do
      let(:product) do
        FG.create(
          :product,
          store_id: 'store_id_1',
          base_price: 20.0,
          current_price: 18.0
        )
      end

      it "returns false" do
        expect(subject).to eq false
      end
    end
  end
end
