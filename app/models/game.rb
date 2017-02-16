class Game < ActiveRecord::Base
  attr_accessible :description, :game_type, :name, :platform
end
