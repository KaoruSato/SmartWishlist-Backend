require 'rails_helper'

describe Product::Maker do
  describe "#call" do
    let(:user) do
      FG.create(:user)
    end

    let(:app_url) do
      "https://itunes.apple.com/us/app/let-me-focus/id1197355361?mt=8"
    end

    subject do
      -> {
        Product::Maker.new(api_client).perform(
          user.id, app_url
        )
      }
    end

    context "everything is awesome" do
      let(:api_client) do
        double(
          get_data: {
            name: 'name of - -- the Product',
            description: 'description',
            base_price: 2.99,
            current_price: 2.99,
            base_price_formatted: "2.99$",
            current_price_formatted: "2.99$",
            currency: 'EUR',
            icon_url: 'http://example.com/sample-icon.png',
            big_icon_url: 'http://example.com/big-sample-icon.png',
            average_user_rating: 4.5,
            user_rating_count: 20
          }
        )
      end

      it "creates a new product" do
        expect {
          subject.call
        }.to change(Product, :count).by(1)
      end

      it "assigns correct attributes to the product" do
        product = subject.call
        expect(product.name).to eq 'name of - -- the Product'
        expect(product.description).to eq 'description'
        expect(product.base_price.to_f).to eq 2.99
        expect(product.current_price.to_f).to eq 2.99
        expect(product.lowest_price.to_f).to eq 2.99
        expect(product.currency).to eq 'EUR'
        expect(product.icon_url).to eq 'http://example.com/sample-icon.png'
        expect(product.big_icon_url).to eq 'http://example.com/big-sample-icon.png'
        expect(product.store_country).to eq 'us'
        expect(product.app_url).to eq app_url
        expect(product.average_user_rating).to eq 4.5
        expect(product.user_rating_count).to eq 20
        expect(product.slug).to include "name-of-the-product"
      end
    end

    context "creating the usd product system user" do
      let(:api_client) do
        double(
          get_data: {
            name: 'name',
            description: 'description',
            base_price: 2.99,
            current_price: 2.99,
            base_price_formatted: "2.99$",
            current_price_formatted: "2.99$",
            currency: 'EUR',
            icon_url: 'http://example.com/sample-icon.png',
            big_icon_url: 'http://example.com/big-sample-icon.png',
            average_user_rating: 4.5,
            user_rating_count: 20
          }
        )
      end

      let(:url_parser) do
        double(
          call: {
            store_id: '123456',
            store_country: 'gb'
          }
        )
      end

      context "original product is from US store" do
        it "does not create a new product" do
          expect {
            subject.call
          }.to change(Product, :count).by(1)
        end
      end

      context "original product is not from US store" do
        let(:app_url) do
          "https://itunes.apple.com/pl/app/let-me-focus/id1197355361?mt=8"
        end

        it "creates a new product from us store" do
          VCR.use_cassette("itunes_correct_US_system_prod") do
            expect {
              subject.call
            }.to change(Product, :count).by(2)
          end
        end

        it "assigns a new product to system user" do
          VCR.use_cassette("itunes_correct_US_system_prod") do
            expect {
              subject.call
            }.to change { User.system_user.products.count }.by(1)
          end
        end
      end
    end

    context "creating the same product twice" do
      let(:api_client) do
        double(
          get_data: {
            name: 'name',
            description: 'description',
            base_price: 2.99,
            current_price: 2.99,
            base_price_formatted: "2.99$",
            current_price_formatted: "2.99$",
            currency: 'EUR',
            icon_url: 'http://example.com/sample-icon.png',
            big_icon_url: 'http://example.com/big-sample-icon.png',
            average_user_rating: 4.5,
            user_rating_count: 20
          }
        )
      end

      it "does not report an error" do
        subject.call
        expect(ExceptionNotifier).not_to receive(:notify_exception)
        subject.call
      end
    end

    context "there was an api error" do
      let(:api_client) do
        double.tap do |mock|
          allow(mock).to receive(:get_data) {
            raise API::StoreNetworkError
          }
        end
      end

      let(:url_parser) do
        double(
          call: {
            store_id: '123456',
            store_country: 'gb'
          }
        )
      end

      it "reports the error" do
        expect(ExceptionNotifier).to receive(:notify_exception)
        subject.call
      end
    end
  end
end
