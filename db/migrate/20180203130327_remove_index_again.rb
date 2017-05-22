class RemoveIndexAgain < ActiveRecord::Migration[5.1]
  def change
    remove_index :discounts, :created_at
  end
end
