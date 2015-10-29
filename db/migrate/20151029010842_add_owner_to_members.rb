class AddOwnerToMembers < ActiveRecord::Migration
  def change
    add_column :members, :owner, :boolean
  end
end
