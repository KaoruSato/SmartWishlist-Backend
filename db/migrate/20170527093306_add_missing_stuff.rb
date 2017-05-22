class AddMissingStuff < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :store_country, :string, null: false
    add_column :products, :base_price_formatted, :string, null: false
    add_column :products, :current_price_formatted, :string, null: false
  end
end
