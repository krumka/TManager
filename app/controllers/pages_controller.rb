class PagesController < ApplicationController
  def home
    @games = Game.last(3)
  end
end
