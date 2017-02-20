class CreatePrograms < ActiveRecord::Migration
  def change
    create_table :programs do |t|
      t.references :game
      t.references :tournament

      t.timestamps
    end
    add_index :programs, :game_id
    add_index :programs, :tournament_id
  end
end
