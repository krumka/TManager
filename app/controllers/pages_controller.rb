class PagesController < ApplicationController
  def home
    @games = Game.last(3)
    @tournaments = Tournament.order(:date).all.last(3)
  end
end
