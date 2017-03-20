class GamesController < ApplicationController
  # GET /games
  # GET /games.json
  def index
    if params[:tournament_id].nil?
      @games = Game.all
    else
      @tournament = Tournament.find(params[:tournament_id])
      @games = @tournament.games
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @games }
    end
  end

  # GET /games/1
  # GET /games/1.json
  def show
    @game = Game.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @game }
    end
  end

  # GET /games/new
  # GET /games/new.json
  def new
    authorize! :new, Game

    if params[:tournament_id].nil?
      @game = Game.new
    else
      @tournament = Tournament.find(params[:tournament_id])
      @games = @tournament.games
    end

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @game }
    end
  end

  # GET /games/1/edit
  def edit
    authorize! :edit, Game

    @game = Game.find(params[:id])
  end

  # POST /games
  # POST /games.json
  def create
    authorize! :create, Game

    @game = Game.new(params[:game])

    respond_to do |format|
      if @game.save
        format.html { redirect_to @game, notice: 'Game was successfully created.' }
        format.json { render json: @game, status: :created, location: @game }
      else
        format.html { render action: "new" }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /games/1
  # PUT /games/1.json
  def update
    authorize! :update, Game

    @game = Game.find(params[:id])

    respond_to do |format|
      if @game.update_attributes(params[:game])
        format.html { redirect_to @game, notice: 'Game was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /games/1
  # DELETE /games/1.json
  def destroy
    authorize! :destroy, Game

    @game = Game.find(params[:id])
    @game.destroy

    respond_to do |format|
      format.html { redirect_to games_url, notice: 'Game deleted' }
      format.json { head :no_content }
    end
  end

  def add_to_tournament
    authorize! :edit, Tournament
    if Tournament.find(params[:tournament_id]).users.nil?
      Tournament.find(params[:tournament_id]).games << Game.find(params[:game_id])
      redirect_to "/tournaments/" + params[:tournament_id] + "/games/new", notice: 'Game added to the tournament'
    else
      redirect_to "/tournaments/" + params[:tournament_id] + "/games/new", notice: 'You can\'t add the game'
    end
  end

  def del_from_tournament
    authorize! :edit, Tournament
    if Tournament.find(params[:tournament_id]).users.nil?
      Tournament.find(params[:tournament_id]).games.delete(Game.find(params[:game_id]))
      redirect_to "/tournaments/" + params[:tournament_id] + "/games/new", notice: 'Game deleted from the tournament'
    else
      redirect_to "/tournaments/" + params[:tournament_id] + "/games/new", notice: 'You can\'t delete the game'
    end
  end
end
