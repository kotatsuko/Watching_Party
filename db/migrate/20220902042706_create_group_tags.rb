class CreateGroupTags < ActiveRecord::Migration[6.1]
  def change
    create_table :group_tags do |t|
      t.integer :tag_id, null: false
      t.integer :group_id, null: false

      t.timestamps
    end
  end
end
