class CreateGroups < ActiveRecord::Migration[6.1]
  def change
    create_table :groups do |t|
      t.integer :owner_user_id, null: false
      t.string :name, null: false
      t.text :introduction, null: false
      t.string :title, null: false
      t.integer :genre, null: false, default: 0
      t.integer :viewing_time, null: false
      t.time :start_time, null: false 

      t.timestamps
    end
  end
end
