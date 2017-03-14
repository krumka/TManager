class Program < ActiveRecord::Base
  belongs_to :game
  belongs_to :tournament
  # attr_accessible :title, :body
  has_many :registrations
  has_many :users, through: :registrations
  has_many :matches
end
