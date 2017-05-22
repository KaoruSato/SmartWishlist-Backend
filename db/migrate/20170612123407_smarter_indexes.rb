class SmarterIndexes < ActiveRecord::Migration[5.1]
  def change
    remove_index :users, column: [:auth_token, :device_token]
    add_index :users, [:auth_token, :device_token], unique: true
    remove_index :products, column: [:store_id]
    remove_index :products, column: [:user_id]
    add_index :products, [:user_id, :store_id], unique: true
  end
end
