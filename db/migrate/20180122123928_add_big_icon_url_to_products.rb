class AddBigIconUrlToProducts < ActiveRecord::Migration[5.1]
  def change
    add_column :products, :big_icon_url, :string
  end
end
