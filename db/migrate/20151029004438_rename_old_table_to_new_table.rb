class RenameOldTableToNewTable < ActiveRecord::Migration
  def change
    rename_table :user_groups, :members
  end
end
