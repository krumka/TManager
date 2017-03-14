class TryingAgainMatches < ActiveRecord::Migration
  def change
    drop_table :matches

    create_table :matches do |t|
      t.references :program
      t.references :player1, references: :users
      t.integer :player1_score
      t.references :player2, references: :users
      t.integer :player2_score

      t.timestamps
    end
  end
end
