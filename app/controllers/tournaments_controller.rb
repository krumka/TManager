class TournamentsController < ApplicationController
  # GET /tournaments
  # GET /tournaments.json
  def index
    @tournaments_to_come = Tournament.order(:date).where("date > ?", DateTime.now)
    @tournaments_past = Tournament.order("date DESC").where("date < ?", DateTime.now)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @tournaments }
    end
  end

  # GET /tournaments/1
  # GET /tournaments/1.json
  def show
    @tournament = Tournament.find(params[:id])
    @games = @tournament.games
    @users = @tournament.users.uniq
    if @tournament.lat.nil? || @tournament.lon.nil?
      @tournament.geocode
    end

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @tournament }
    end
  end

  # GET /tournaments/new
  # GET /tournaments/new.json
  def new
    authorize! :new, Tournament

    @tournament = Tournament.order(:date).new
    @games = Game.all

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @tournament }
    end
  end

  # GET /tournaments/1/edit
  def edit
    authorize! :edit, Tournament

    @tournament = Tournament.find(params[:id])
    @games = Game.all
  end

  # POST /tournaments
  # POST /tournaments.json
  def create
    authorize! :create, Tournament

    @tournament = Tournament.new(params[:tournament])

    respond_to do |format|
      if @tournament.save
        format.html { redirect_to @tournament, notice: 'Tournament was successfully created.' }
        format.json { render json: @tournament, status: :created, location: @tournament }
      else
        format.html { render action: "new" }
        format.json { render json: @tournament.errors, status: :unprocessable_entity }
      end
    end
  end

  def set_scores
    authorize! :edit, Match

    @tournament = Tournament.find(params[:tournament_id])
    @matches = @tournament.matches
  end

  # PUT /tournaments/1
  # PUT /tournaments/1.json
  def update
    authorize! :update, Tournament

    @tournament = Tournament.find(params[:id])

    respond_to do |format|
      if @tournament.update_attributes(params[:tournament])
        format.html { redirect_to @tournament, notice: 'Tournament was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @tournament.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tournaments/1
  # DELETE /tournaments/1.json
  def destroy
    authorize! :destroy, Tournament

    @tournament = Tournament.find(params[:id])
    @tournament.destroy

    respond_to do |format|
      format.html { redirect_to tournaments_url, notice: 'Tournament is deleted' }
      format.json { head :no_content }
    end
  end

  def generate_matches
    authorize! :edit, Tournament
    authorize! :create, Match

    @tournament = Tournament.find(params[:tournament_id])
    redirect_to @tournament, notice: @tournament.generate_matches
  end

  def addGame2Tournament
    if Tournament.find(params[:tournament_id]).users.nil?
      Tournament.find(params[:tournament_id]).games << Game.find(params[:game_id])
      html = "<div class=\"row game\"><div class=\"col-xs-6 game_name\"><a href=\"/games/#{params[:game_id]}\">#{Game.find(params[:game_id]).name}</a></div><div class=\"col-xs-6\"><a href=\"#{params[:game_id]}\" class=\"btn btn-primary btn-up btn-delete-game\" id=\"delete_game\" style=\"margin-left: 20px;text-decoration: none;\">Delete</a></div></div>"
      render json: {html: html}
    else
      render json: {delete: false}
    end
  end

  def deleteGame2Tournament
    if Tournament.find(params[:tournament_id]).users.nil?
      if Tournament.find(params[:tournament_id]).games.delete(Game.find(params[:game_id]))
        html = "<option value=\"" + params[:game_id] + "\">" + Game.find(params[:game_id]).name + "</option>"
        render json: {delete: true, html: html}
      else
        render json: {delete: false}
      end
    else
      render json: {delete: false}
    end
  end

  def api_generate_matches
    authorize! :edit, Tournament
    authorize! :create, Match

    @tournament = Tournament.find(params[:tournament_id])

    if @tournament.generate_matches
      html = view_context.render :partial => 'matches'
      render json: {generate: true, html: html}
    end
  end
end
