require 'rails_helper'

describe Product::UrlParser do
  describe "call" do
    subject do
      Product::UrlParser.call(raw_url)
    end

    context "correct url" do
      let(:raw_url) do
        "https://itunes.apple.com/pl/app/olli-by-tinrocket/id1039012834?mt=8"
      end

      it "extracts product id and store country code from it" do
        result = subject
        expect(result.fetch(:store_country)).to eq "pl"
        expect(result.fetch(:store_id)).to eq "1039012834"
      end
    end

    context "incorrect url" do
      let(:raw_url) do
        # also redirects, but invalid target url
        "http://price-watcher-app.herokuapp.com"
      end

      it "raises an expected error" do
        expect {
          subject
        }.to raise_error(StandardError)
      end
    end
  end
end
