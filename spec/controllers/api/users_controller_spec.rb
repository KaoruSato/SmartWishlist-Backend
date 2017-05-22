require 'rails_helper'

describe API::UsersController do
  describe "#create" do
    let(:params) do
      {
        auth_token: 'client_generated_token',
        device_token: 'uniq_device_token',
        sandbox: false,
        store_country: "US",
        timezone: "Europe/Berlin"
      }
    end

    context "user does not yet exist" do
      it "creates a new user" do
        expect {
          post :create, params: params
        }.to change(User, :count).by(1)
      end

      it "calls the User::Maker service" do
        expect(User::Maker).to receive(:call) {
          double(
            timezone: 'USA/Chicago',
            store_country: 'US'
          )
        }
        post :create, params: params
      end

      it "returns a correct response" do
        post :create, params: params
        expect(json_response.fetch(:status)).to eq "created"
        expect(response.status).to eq 201
      end
    end

    context "user already exist" do
      before do
        FG.create(:user,
          auth_token: 'client_generated_token',
          device_token: 'uniq_device_token'
        )
      end

      it "does not create a new user" do
        expect {
          post :create, params: params
        }.not_to change(User, :count)
      end

      it "does not call the User::Maker service" do
        expect(User::Maker).not_to receive(:call)
        post :create, params: params
      end

      it "returns a correct response" do
        post :create, params: params
        expect(json_response.fetch(:status)).to eq "exists"
        expect(response.status).to eq 200
      end
    end

    context "invalid params" do
      it "returns 400 status code" do
        post :create, params: { bad: "data" }
        expect(response.status).to eq 400
      end

      it "executes exception notifier" do
        expect(ExceptionNotifier).to receive(:notify_exception)
        post :create, params: { bad: "data" }
      end
    end
  end

  describe "#update" do
    let(:params) do
      {
        auth_token: 'client_generated_token',
        device_token: 'uniq_device_token',
        device_push_token: 'new_push_token'
      }
    end

    context "user authentication failed" do
      it "returns 401 status code" do
        put :update, params: params
        expect(response.status).to eq 401
      end
    end

    context "user authentication successful" do
      let!(:user) do
        FG.create(:user,
          auth_token: 'client_generated_token',
          device_token: 'uniq_device_token',
          device_push_token: nil
        )
      end

      it "updates the correct user attributes" do
        expect {
          put :update, params: params
        }.to change { user.reload.device_push_token }
        .from(nil).to("new_push_token")
      end

      it "returns correct http code" do
        put :update, params: params
        expect(response.status).to eq 200
      end
    end
  end
end
