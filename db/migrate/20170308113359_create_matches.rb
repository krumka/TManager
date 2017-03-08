class CreateMatches < ActiveRecord::Migration
  def change
    create_table :matches do |t|
      t.integer :program_id
      t.integer :player1_id
      t.integer :player1_score
      t.integer :player2_id
      t.integer :player2_score

      t.timestamps
    end
  end
end
