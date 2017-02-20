class Program < ActiveRecord::Base
  belongs_to :game
  belongs_to :tournament
  # attr_accessible :title, :body
end
