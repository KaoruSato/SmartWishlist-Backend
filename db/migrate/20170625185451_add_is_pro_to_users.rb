class AddIsProToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :is_pro, :boolean, null: false, default: false
  end
end
