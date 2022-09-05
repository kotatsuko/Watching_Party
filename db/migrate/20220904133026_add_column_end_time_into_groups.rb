class AddColumnEndTimeIntoGroups < ActiveRecord::Migration[6.1]
  def change
    add_column :groups, :end_time, :datetime
  end
end
