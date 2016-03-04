class RemoveIndexUserIdOnGroupId < ActiveRecord::Migration
  def change
    remove_index(:members, name: "index_members_on_user_id_and_group_id")
  end
end
