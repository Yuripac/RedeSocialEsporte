class RemoveUserIdFromSports < ActiveRecord::Migration
  def change
    remove_column :sports, :user_id, :integer
  end
end
