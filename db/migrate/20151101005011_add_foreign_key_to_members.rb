class AddForeignKeyToMembers < ActiveRecord::Migration
  def change
    add_foreign_key :members, :users
    add_foreign_key :members, :groups
  end
end
