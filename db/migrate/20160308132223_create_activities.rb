class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.string :latitude
      t.string :longitude
      t.string :address
      t.integer :group_id

      t.timestamps null: false
    end
  end
end
