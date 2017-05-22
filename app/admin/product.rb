ActiveAdmin.register Product do
  scope :currently_discounted
  scope :currently_discounted_usd

  %i(name store_country currency).each do |filter_name|
    filter filter_name
  end

  index do
    selectable_column
    column :name
    column :currency
    column :base_price_formatted
    column :current_price_formatted
    column :user
    column :created_at
    column :store_link do |product|
      link_to "#{product.store_country} store", product.app_url, target: "_blank"
    end

    actions
  end

  form do |f|
    f.inputs do
      f.input :store_id
      f.input :name
      f.input :description
      f.input :currency
      f.input :base_price
      f.input :current_price
      f.input :user
    end
    f.actions
  end

  controller do
    def permitted_params
      params.permit!
    end
  end
end
