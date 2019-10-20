class AddWho < ActiveRecord::Migration[5.1]
  def change
    add_reference :posts, :user, foreign_key: true
    add_column :users, :image, :string
  end
end
