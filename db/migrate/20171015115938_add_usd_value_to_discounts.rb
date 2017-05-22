class AddUsdValueToDiscounts < ActiveRecord::Migration[5.1]
  def change
    add_column :discounts, :usd_value, :decimal, precision: 8, scale: 2
  end
end
