class ChangeDatatypeStartTimeOfGroups < ActiveRecord::Migration[6.1]
  def change
    change_column :groups, :start_time, :datetime
  end
end
