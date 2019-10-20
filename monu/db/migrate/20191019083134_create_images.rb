class CreateImages < ActiveRecord::Migration[5.1]
  def change
    create_table :images do |t|
      t.references :user, foreign_key: true
      t.binary :image
      t.string :title
      t.string :name
      t.timestamps
    end
  end
end
