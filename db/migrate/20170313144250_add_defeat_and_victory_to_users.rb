class AddDefeatAndVictoryToUsers < ActiveRecord::Migration
  def change
    add_column :users, :nb_victory,    :integer
    add_column :users, :nb_defeat,    :integer
  end
end
