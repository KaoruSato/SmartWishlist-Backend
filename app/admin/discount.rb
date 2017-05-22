ActiveAdmin.register Discount do
  includes :product
  scope :was_tweeted

  sidebar "Total discounts value" do
    render partial: "total_value"
  end

  %i(was_tweeted created_at).each do |filter_name|
    filter filter_name
  end

  index do

    selectable_column
    column :from_price
    column :to_price
    column :product
    column :was_tweeted
    column :currency do |discount|
      discount.currency
    end
    column :value
    column :usd_value
    column :ratio do |discount|
      "#{discount.ratio}%"
    end
    column :created_at
  end

  controller do
    def permitted_params
      params.permit!
    end
  end
end
