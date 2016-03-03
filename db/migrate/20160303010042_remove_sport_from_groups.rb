class RemoveSportFromGroups < ActiveRecord::Migration
  def change
    remove_column :groups, :sport, :string
  end
end
