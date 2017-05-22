require 'rails_helper'

describe User::Maker do
  describe "#call" do
    let(:user_params) do
      {
        auth_token: 'client_generated_token',
        device_token: 'uniq_device_token',
        sandbox: false,
        store_country: "US",
        timezone: "Asia/Kathmandu"
      }
    end

    subject do
      User::Maker.call(user_params)
    end

    it "creates a new user" do
      expect {
        subject
      }.to change(User, :count).by(1)
    end

    it "assigns a correct params to a new user object" do
      user = subject
      expect(user.auth_token).to eq 'client_generated_token'
      expect(user.device_token).to eq 'uniq_device_token'
      expect(user.timezone).to eq "Asia/Kathmandu"
      expect(user.sandbox).to eq false
      expect(user.last_active).not_to be_nil
    end
  end
end
