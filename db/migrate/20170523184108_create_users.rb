class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :auth_token, null: false
      t.string :device_token, null: false
      t.datetime :last_active, null: false
      t.string :device_push_token
      t.string :timezone, null: false
      t.boolean :sandbox, null: false

      t.timestamps
    end
    add_index :users, [:auth_token, :device_token]

    add_column :products, :user_id, :integer, null: false
    add_index :products, :user_id
    add_foreign_key :products, :users
  end
end
