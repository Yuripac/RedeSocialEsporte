class AddDeleteCascadeToMembers < ActiveRecord::Migration
  def change
    add_foreign_key :members, :users, column: :user_id, primary_key: :id
    add_foreign_key :members, :groups, column: :group_id, primary_key: :id
  end
end
