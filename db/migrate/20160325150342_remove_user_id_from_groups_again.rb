class RemoveUserIdFromGroupsAgain < ActiveRecord::Migration
  def change
    remove_column :groups, :user_id, :integer
    remove_column :memberships, :owner, :boolean
  end
end
