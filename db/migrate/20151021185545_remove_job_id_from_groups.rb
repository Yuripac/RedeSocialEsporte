class RemoveJobIdFromGroups < ActiveRecord::Migration
  def change
    remove_column :groups, :job_id, :integer
  end
end
