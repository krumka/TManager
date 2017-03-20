class UserMailer < ActionMailer::Base
  default from: "notifications@lambre.me"
  layout "mailer"

  def subscribe_tournament(tournament, game, user)
    @user = user
    @tournament = tournament
    @game = game
    mail(to: @user.email, subject: 'New subscription to '+tournament.name)
  end

  def match_played(user, opponent, match)
    @user = user
    @opponent = opponent
    @match = match
    mail(to: @user.email, subject: 'Your score in '+ @match.games.first.name + " for the tournament "+@match.tournaments.first.name + " has been updated")
  end
end
