class RemakeMatches < ActiveRecord::Migration
  def change
    drop_table :matches

    create_table :matches do |t|
      t.references :program
      t.references :player1, index: true, foreign_key: {to_table: :users}
      t.integer :player1_score
      t.references :player2, index: true, foreign_key: {to_table: :users}
      t.integer :player2_score

      t.timestamps
    end
  end
end
