class ChangeStoreCountry < ActiveRecord::Migration[5.1]
  def change
    remove_column :users, :store_country, :string
    add_column :users, :store_country, :string
    add_column :products, :store_country, :string, null: false
  end
end
