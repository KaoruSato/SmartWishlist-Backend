class AddRatingsIndex < ActiveRecord::Migration[5.1]
  def change
    add_index :products, [:average_user_rating, :user_rating_count]
  end
end
