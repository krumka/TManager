class Tournament < ActiveRecord::Base
  attr_accessible :adress, :date, :description, :max_gamers, :name
  has_many :programs
  has_many :games, through: :programs
end
