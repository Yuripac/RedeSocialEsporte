class AddOwnerToMembershipsAgain2 < ActiveRecord::Migration
  def change
    change_column :memberships, :owner, :boolean, default: false
  end
end
