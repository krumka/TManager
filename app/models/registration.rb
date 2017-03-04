class Registration < ActiveRecord::Base
  belongs_to :program
  belongs_to :user
  has_many :tournaments, through: :program
  attr_accessible :current_password
end
