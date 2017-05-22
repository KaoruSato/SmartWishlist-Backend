if Rails.env.test? || Rails.env.development?
  Rswag::Ui.configure do |c|
    c.swagger_endpoint '/api-docs/v1/swagger.json', 'API V1 Docs'
  end

  Rswag::Api.configure do |c|
    c.swagger_root = Rails.root.to_s + '/swagger'
  end
end
