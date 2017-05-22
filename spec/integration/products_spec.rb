require 'swagger_helper'

describe 'Products API' do
  path '/api/products' do
    post 'Creates a product' do
      consumes 'application/json'
      parameter name: :product, in: :body, schema: {
        type: :object,
        properties: {
          auth_token: { type: :string, default: 'auth_token' },
          device_token: { type: :string, default: 'device_token' },
          store_id: { type: :string, default: "992625902" },
          app_url: { type: :string, default: "https://itunes.apple.com/us/app/let-me-focus/id1197355361?mt=8" }
        },
        required: [
          "auth_token",
          "device_token",
          "store_id"
        ]
      }

      response '201', 'Product created' do
        run_test! unless Rails.env.test?
      end
    end

    get 'Lists user products' do
      consumes 'application/json'
      parameter name: :auth_token, in: :query, type: :string, default: 'auth_token'
      parameter name: :device_token, in: :query, type: :string, default: 'device_token'

      response '200', 'User products listed' do
        run_test! unless Rails.env.test?
      end
    end

    delete 'Removes target product' do
      consumes 'application/json'
      parameter name: :auth_token, in: :query, type: :string, default: 'auth_token'
      parameter name: :device_token, in: :query, type: :string, default: 'device_token'
      parameter name: :store_id, in: :query, type: :string, default: 'store_id'

      response '200', 'Target product removed' do
        run_test! unless Rails.env.test?
      end
    end
  end
end
