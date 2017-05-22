class CreateProducts < ActiveRecord::Migration[5.1]
  def change
    create_table :products do |t|
      t.string :store_id, null: false
      t.string :name, null: false
      t.text :description, null: false
      t.decimal :base_price, precision: 8, scale: 2, null: false
      t.decimal :current_price, precision: 8, scale: 2
      t.string :currency, null: false
      t.string :icon_url, null: false

      t.timestamps
    end

    add_index :products, :store_id
  end
end
