class AddSportIdToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :sport_id, :integer
  end
end
