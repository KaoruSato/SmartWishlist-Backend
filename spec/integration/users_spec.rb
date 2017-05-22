require 'swagger_helper'

describe 'Users API' do
  path '/api/users' do
    post 'Creates a user' do
      consumes 'application/json'
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          auth_token: { type: :string, default: 'auth_token' },
          device_token: { type: :string, default: 'device_token' },
          sandbox: { type: :boolean, default: 'false' },
          store_country: { type: :string, default: 'US' },
          timezone: { type: :string, default: "Europe/Berlin" }
        },
        required: [
          "auth_token",
          "device_token",
          "sandbox",
          "store_country",
          "timezone"
        ]
      }

      response '201', 'User created' do
        run_test! unless Rails.env.test?
      end
    end

    put 'Updates a user' do
      consumes 'application/json'
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          auth_token: { type: :string, default: 'auth_token' },
          device_token: { type: :string, default: 'device_token' },
          device_push_token: { type: :string, default: 'device_push_token' }
        },
        required: [
          "auth_token",
          "device_token",
          "device_push_token"
        ]
      }

      response '200', 'User updated' do
        run_test! unless Rails.env.test?
      end
    end
  end
end
