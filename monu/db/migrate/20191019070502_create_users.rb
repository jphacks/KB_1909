class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.string :password_digest
      t.string :token
      t.timestamps
    end
    add_index :users, :email, :unique => true
    add_index :users, :token, :unique => true
    add_index :posts, :longitude
    add_index :posts, :latitude
  end
end
