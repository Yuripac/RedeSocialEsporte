class CreateParticipations < ActiveRecord::Migration
  def change
    create_table :participations do |t|
      t.integer :user_id
      t.integer :activity_id

      t.index([:user_id, :activity_id], unique: true)

      t.timestamps null: false
    end
  end
end
