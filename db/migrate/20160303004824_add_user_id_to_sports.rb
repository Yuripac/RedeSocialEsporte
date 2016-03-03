class AddUserIdToSports < ActiveRecord::Migration
  def change
    add_column :sports, :user_id, :integer
  end
end
