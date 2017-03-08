class AddLatLongTournamentsAndUsers < ActiveRecord::Migration
  def change
    add_column :tournaments, :lat,    :float
    add_column :tournaments, :lon,    :float
    add_column :users, :lon,    :float
    add_column :users, :lat,    :float
  end
end
