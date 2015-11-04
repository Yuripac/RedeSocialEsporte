class RemoveUserIdAndGroupIdFromMembers < ActiveRecord::Migration
  def change
    remove_column :members, :user_id
    remove_column :members, :group_id
  end
end
