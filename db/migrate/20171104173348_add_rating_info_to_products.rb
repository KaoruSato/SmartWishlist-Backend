class AddRatingInfoToProducts < ActiveRecord::Migration[5.1]
  def change
    add_column :products, :average_user_rating, :float, default: 0, null: false
    add_column :products, :user_rating_count, :integer, default: 0, null: false
  end
end
