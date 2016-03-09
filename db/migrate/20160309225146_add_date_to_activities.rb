class AddDateToActivities < ActiveRecord::Migration
  def change
    add_column :activities, :date, :datetime
  end
end
