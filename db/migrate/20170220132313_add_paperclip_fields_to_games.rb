class AddPaperclipFieldsToGames < ActiveRecord::Migration
  def change
    add_column :games_images, :image_file_name,    :string
    add_column :games_images, :image_content_type, :string
    add_column :games_images, :image_file_size,    :integer
    add_column :games_images, :image_updated_at,   :datetime
  end
end
