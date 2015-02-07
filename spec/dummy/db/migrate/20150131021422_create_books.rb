class CreateBooks < ActiveRecord::Migration
  def change
    create_table :books do |t|
      t.float :rating
      t.integer :user_id
      t.string :title
      t.timestamps null: false
    end
  end
end
