class AddIndexToUserIdAndGroupIdFromUserGroups < ActiveRecord::Migration
  def change
    add_index :user_groups, [:user_id, :group_id], unique: true
  end
end
