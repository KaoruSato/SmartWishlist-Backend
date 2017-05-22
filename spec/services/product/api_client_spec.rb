require 'rails_helper'

describe Product::ApiClient do
  subject do
    Product::ApiClient.build
  end

  let(:store_id) { '992625902' } # Tracky

  describe "get_data" do
    context "data fetch successful" do
      it "returns a correct data" do
        result = VCR.use_cassette("itunes_correct_US_service") do
          subject.get_data(store_id: store_id)
        end

        expect(result.fetch(:name)).to eq "Tracky - Time Tracker for Slack"
        expect(result.fetch(:description)).not_to be_empty
        expect(result.fetch(:base_price)).to eq 1.99
        expect(result.fetch(:current_price)).to eq 1.99
        expect(result.fetch(:currency)).to eq "USD"
        expect(result.fetch(:icon_url)).to eq "http://is1.mzstatic.com/image/thumb/Purple69/v4/72/a3/7f/72a37fbb-63d2-f6a5-ca4d-2983cd778a89/source/100x100bb.jpg"
      end
    end

    context "fetching data from a different country store" do
      it "returns a correct data" do
        result = VCR.use_cassette("itunes_correct_GB") do
          subject.get_data(store_id: store_id, store_country: "GB")
        end

        expect(result.fetch(:currency)).to eq "GBP"
      end
    end

    context "product was not found by store_id" do
      it "raises a correct error" do
        expect {
          VCR.use_cassette("itunes_product_not_found") do
            subject.get_data(store_id: '000000')
          end
        }.to raise_error(API::NotFoundByStoreId)
      end
    end

    context "store was not found by country_code" do
      it "raises a correct error" do
        expect {
          VCR.use_cassette("itunes_country_store_error") do
            subject.get_data(store_id: store_id, store_country: 'AA')
          end
        }.to raise_error(API::CountryStoreNotFound)
      end
    end

    context "could not fetch the data" do
      it "raises the correct error" do
        expect {
          VCR.use_cassette("itunes_error") do
            subject.get_data(store_id: store_id)
          end
        }.to raise_error(API::StoreNetworkError)
      end
    end
  end
end
