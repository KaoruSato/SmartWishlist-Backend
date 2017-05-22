require 'rails_helper'
describe API::ProductsController do
  let!(:user) do
    FG.create(:user,
      auth_token: 'client_generated_token',
      device_token: 'uniq_device_token'
    )
  end

  let(:params) do
    {
      auth_token: 'client_generated_token',
      device_token: 'uniq_device_token'
    }
  end

  describe "#create" do
    let(:product_params) do
      params.merge({
        app_url: 'https://itunes.apple.com/us/app/let-me-focus/id1197355361?mt=8'
      })
    end

    context "there was a data fetch error" do
      before do
        allow(Product::ApiClient).to receive(:new) {
          raise API::StoreNetworkError
        }
      end

      it "returns a correct response code" do
        post :create, params: product_params
        expect(response.status).to eq 502
      end
    end

    context "product creation successful" do
      it "returns a correct status code" do
        VCR.use_cassette("itunes_correct_US_integration",match_requests_on: [:method, :path]) do
          post :create, params: product_params
        end
        expect(response.status).to eq 201
      end

      it "creates a new product" do
        expect {
          VCR.use_cassette("itunes_correct_US_integration", match_requests_on: [:method, :path]) do
            post :create, params: product_params
          end
        }.to change(Product, :count).by(1)
      end

      it "calls a correct service object" do
        expect(Product::Maker).to receive(:run)
        post :create, params: product_params
      end
    end
  end

  describe "#index" do
    before do
      3.times do
        FG.create(:product, user: user)
      end
    end

    it "returns a list of correct user's products" do
      get :index, params: params
      expect(json_response.fetch(:products).count).to eq 3
    end

    it "returns a correct user product attributes" do
      get :index, params: params
      product = json_response.fetch(:products).first
      expect(product.fetch(:store_id)).not_to be_nil
      expect(product.fetch(:name)).not_to be_nil
      expect(product.fetch(:description)).not_to be_nil
      expect(product.fetch(:base_price)).not_to be_nil
      expect(product.fetch(:current_price)).not_to be_nil
      expect(product.fetch(:base_price_formatted)).not_to be_nil
      expect(product.fetch(:current_price_formatted)).not_to be_nil
      expect(product.fetch(:currency)).not_to be_nil
      expect(product.fetch(:icon_url)).not_to be_nil
    end
  end

  describe "#destroy" do
    let!(:product) do
      FG.create(:product, store_id: "remove_me")
    end

    let(:params) do
      {
        auth_token: product.user.auth_token,
        device_token: product.user.device_token,
        store_id: product.store_id
      }
    end

    context "object exists" do
      it "removes the correct object" do
        delete :destroy, params: params
        expect(
          Product.find_by(store_id: params.fetch(:store_id)
        )).to eq nil
      end

      it "returns a correct status code" do
        delete :destroy, params: params
        expect(response.status).to eq 200
      end
    end

    context "object does not exist" do
      it "returns a correct status code" do
        delete :destroy, params: params.merge(store_id: "incorrect")
        expect(response.status).to eq 404
      end

      it "does not destroy other objects" do
        expect {
          delete :destroy, params: params.merge(store_id: "incorrect")
        }.not_to change(Product, :count)
      end
    end
  end
end
