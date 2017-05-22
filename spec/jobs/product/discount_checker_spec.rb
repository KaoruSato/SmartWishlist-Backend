require 'rails_helper'

describe Product::DiscountChecker do
  let(:user) do
    FG.create(:user)
  end

  let(:product) do
    FG.create(:product,
      user: user,
      base_price: 2.99,
      current_price: 2.99,
      current_price_formatted: "2.99$",
    )
  end

  before do
    User::DiscountNotifier.push_provider = -> (_, __) {}
  end

  subject do
    Product::DiscountChecker.new(api_client).perform(product.id)
  end

  describe "perform" do
    context "price is stable" do
      let(:api_client) do
        double(
          get_data: {
            current_price: 2.99,
            current_price_formatted: "2.99$",
            average_user_rating: 4.5,
            user_rating_count: 29
          }
        )
      end

      it "does not notify a user" do
        expect(User::DiscountNotifier).not_to receive(:call)
        subject
      end
    end

    context "there is a discount" do
      let(:api_client) do
        double(
          get_data: {
            current_price: 1.99,
            current_price_formatted: "1.99$",
            average_user_rating: 4.5,
            user_rating_count: 29
          }
        )
      end

      it "saves the lower price as current price and updates formatted price" do
        subject
        expect(product.reload.current_price.to_f).to eq 1.99
        expect(product.reload.current_price_formatted).to eq "1.99$"
      end

      it "creates a new discount object" do
        expect {
          subject
        }.to change(Discount, :count).by(1)
      end

      it "notifies the user" do
        expect(User::DiscountNotifier).to receive(:call)
        .with(product)
        subject
      end
    end

    context "product not found by store id" do
      let(:api_client) do
        double(
          get_data: nil
        )
      end

      before do
        allow(api_client).to receive(:get_data) {
          raise API::NotFoundByStoreId
        }
      end

      it "removes the incorrect product" do
        subject
        expect(Product.find_by(store_id: product.store_id)).to be_nil
      end
    end

    context "price went up" do
      let(:api_client) do
        double(
          get_data: {
            current_price: 3.99,
            current_price_formatted: "3.99$",
            average_user_rating: 4.5,
            user_rating_count: 29
          }
        )
      end

      it "does saves the higher price" do
        subject
        expect(product.reload.current_price.to_f).to eq 3.99
        expect(product.reload.current_price_formatted).to eq "3.99$"
      end
    end

    context "price went down but then it went up" do
      let(:api_client) do
        double(
          get_data: {
            current_price: 3.99,
            current_price_formatted: "3.99$",
            average_user_rating: 4.5,
            user_rating_count: 29
          }
        )
      end

      before do
        product.update!(
          current_price: 1.99,
          current_price_formatted: "1.99$"
        )
      end

      it "does not send the notification" do
        expect(User::DiscountNotifier).not_to receive(:call)
        subject
      end
    end
  end
end
