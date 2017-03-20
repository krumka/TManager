class Match < ActiveRecord::Base
  attr_accessible :player1, :player1_score, :player2, :player2_score, :program_id
  after_save :count_points

  belongs_to :player1, class_name: "User"
  belongs_to :player2, class_name: "User"
  belongs_to :program
  has_many :games, through: :program
  has_many :tournaments, through: :program

  def score
    ("<span class=\"score_p1\">" + self.player1_score.to_s + "</span> - <span class=\"score_p2\">" + self.player2_score.to_s + "</span>").html_safe
  end

  def count_points
    self.player1.calculate_points
    self.player2.calculate_points
  end
end
