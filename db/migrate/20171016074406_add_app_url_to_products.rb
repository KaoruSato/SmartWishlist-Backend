class AddAppUrlToProducts < ActiveRecord::Migration[5.1]
  def change
    add_column :products, :app_url, :string
  end
end
