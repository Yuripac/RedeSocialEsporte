class AddSportToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :sport, :string
  end
end
