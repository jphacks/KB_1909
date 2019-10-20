class ChangeUser < ActiveRecord::Migration[5.1]
  def change
    remove_column :images, :user_id, :integer
    add_reference :images, :post, foreign_key: true
  end
end
