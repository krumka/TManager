class Game < ActiveRecord::Base
  attr_accessible :description, :game_type, :name, :platform
  has_many :programs
  has_many :tournaments, through: :programs
end
