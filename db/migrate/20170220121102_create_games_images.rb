class CreateGamesImages < ActiveRecord::Migration
  def change
    create_table :games_images do |t|
      t.references :game

      t.timestamps
    end
  end
end
