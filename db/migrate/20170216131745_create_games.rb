class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.string :name,        :null => false
      t.string :game_type,   :null => false
      t.string :platform,    :null => false
      t.text :description,    :null => false

      t.string :image_file_name
      t.string :image_content_type
      t.integer :image_file_size
      t.datetime :image_updated_at

      t.timestamps
    end

    add_index :games, :name, unique: true
  end
end
