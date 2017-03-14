class PagesController < ApplicationController
  def home
    @games = Game.order("created_at DESC").first(3)
    @tournaments = Tournament.order("date").where("date > ?", DateTime.now).first(3)
  end
end
