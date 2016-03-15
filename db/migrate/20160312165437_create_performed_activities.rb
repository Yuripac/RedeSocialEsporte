class CreatePerformedActivities < ActiveRecord::Migration
  def change
    create_table :performed_activities do |t|
      t.string :latitude
      t.string :longitude
      t.string :address
      t.integer :group_id
      t.datetime :performed_at

      t.timestamps null: false
    end
  end
end
