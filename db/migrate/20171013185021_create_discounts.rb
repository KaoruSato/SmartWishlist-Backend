class CreateDiscounts < ActiveRecord::Migration[5.1]
  def change
    create_table :discounts do |t|
      t.integer :product_id, null: false
      t.string :store_id, null: false
      t.decimal :from_price, precision: 8, scale: 2, null: false
      t.decimal :to_price, precision: 8, scale: 2, null: false
      t.decimal :from_price_usd, precision: 8, scale: 2
      t.decimal :to_price_usd, precision: 8, scale: 2
      t.boolean :was_tweeted, default: false, null: false

      t.timestamps
    end
    add_index :discounts, :product_id
    add_index :discounts, :store_id
  end
end
