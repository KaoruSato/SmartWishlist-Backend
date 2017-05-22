class RenameCurrencyField < ActiveRecord::Migration[5.1]
  def change
    rename_column :currencies, :usd_ratio, :usd_rate
    remove_column :currencies, :usd_rate, :decimal
    add_column :currencies, :usd_rate, :decimal, precision: 9, scale: 4
    add_index :currencies, :name
  end
end
