class AddUserAndGroupRefToMembers < ActiveRecord::Migration
  def change
    add_reference :members, :user, index: true, foreign_key: true, on_delete: :cascade
    add_reference :members, :group, index: true, foreign_key: true, on_delete: :cascade
  end
end
