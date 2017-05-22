class AddDiscountRatioToProducts < ActiveRecord::Migration[5.1]
  def change
    add_column :products, :discount_ratio, :integer, default: 0, null: false
  end
end
