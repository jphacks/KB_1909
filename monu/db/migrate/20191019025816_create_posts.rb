class CreatePosts < ActiveRecord::Migration[5.1]
  def change
    create_table :posts do |t|
      t.float :longitude
      t.float :latitude
      t.string :url
      t.text :body
      t.timestamps
    end
  end
end
