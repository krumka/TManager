class CreateTournaments < ActiveRecord::Migration
  def change
    create_table :tournaments do |t|
      t.string :name
      t.string :adress
      t.text :description
      t.datetime :date
      t.integer :max_gamers

      t.timestamps
    end
  end
end
