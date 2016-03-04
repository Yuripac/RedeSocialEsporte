class ChangeTableNameMembers < ActiveRecord::Migration
  def change
    rename_table :members, :membership
  end
end
