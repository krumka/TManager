class Registration < ActiveRecord::Base
  belongs_to :program
  belongs_to :user
  # attr_accessible :title, :body
end
