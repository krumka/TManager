class Tournament < ActiveRecord::Base
  attr_accessible :adress, :date, :description, :max_gamers, :name
  has_many :programs
  has_many :games, through: :programs
  has_many :registrations, through: :programs
  has_many :users, through: :registrations
  has_many :matches, through: :programs
  geocoded_by :adress, latitude: :lat, longitude: :lon
  after_validation :geocode, if: ->(obj){ obj.adress.present? and obj.adress_changed? }

  def generate_matches
    nb_matches = 0
    self.programs.each do |p|
      p.users.size.times do |p1|
        (p.users.size - (p1+1)).times do |p2|
          m = p.matches.new
          m.player1_id = p.users[p1].id
          m.player2_id = p.users[p2+p1+1].id
          m.save
          nb_matches += 1
        end
      end
    end
    nb_matches.to_s + " Match(s) ont été créés."
  end
end
