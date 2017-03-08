class Match < ActiveRecord::Base
  attr_accessible :player1_id, :player1_score, :player2_id, :player2_score, :program_id
end
