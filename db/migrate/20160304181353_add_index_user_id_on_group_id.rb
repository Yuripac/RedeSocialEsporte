class AddIndexUserIdOnGroupId < ActiveRecord::Migration
  def change
    add_index :members, [:user_id, :group_id], unique: true
  end
end
