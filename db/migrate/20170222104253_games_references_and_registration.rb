class GamesReferencesAndRegistration < ActiveRecord::Migration
  def change
    create_table :registrations do |t|
      t.references :program
      t.references :user

      t.timestamps
    end
  end
end
