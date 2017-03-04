class Game < ActiveRecord::Base
  attr_accessible :description, :game_type, :name, :platform, :image
  has_many :programs
  has_many :tournaments, through: :programs
  has_many :registrations, through: :programs
  has_many :users, through: :registrations

  has_attached_file :image, styles: { medium: "1920x510>", thumb: "250x66>" }, :default_url => "/images/:style/no_image.png"
  validates_attachment_content_type :image, :content_type => ["image/jpg", "image/jpeg", "image/png"]
end
