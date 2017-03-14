class AddingForeignKeys < ActiveRecord::Migration
  def change
    drop_table :matches

    create_table :matches do |t|
      t.references :program
      t.belongs_to :player1
      t.integer :player1_score
      t.belongs_to :player2
      t.integer :player2_score

      t.timestamps
    end
  end
end
