class RemoveOwnerFromMembers < ActiveRecord::Migration
  def change
    remove_column :members, :owner, :boolean
  end
end
