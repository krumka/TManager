class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username
      t.string :email
      t.string :password
      t.string :adress
      t.string :country
      t.integer :role

      t.timestamps
    end

    add_index :users, :email, unique: true
    add_index :users, :username, unique: true

  end
end
