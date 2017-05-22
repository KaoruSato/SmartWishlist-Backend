class AddIndexToDiscountsCreatedAt < ActiveRecord::Migration[5.1]
  def change
    add_index :discounts, :created_at
  end
end
