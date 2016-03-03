class RemoveFavoriteSportFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :favorite_sport, :string
  end
end
