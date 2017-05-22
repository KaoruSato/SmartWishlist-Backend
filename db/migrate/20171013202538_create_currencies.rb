class CreateCurrencies < ActiveRecord::Migration[5.1]
  def change
    create_table :currencies do |t|
      t.string :name, null: false
      t.decimal :usd_ratio, precision: 8, scale: 2, null: false
      t.timestamps
    end
  end
end
