class MatchesController < ApplicationController
  # GET /matches
  # GET /matches.json
  def index
    authorize! :index, Match

    @matches = Match.order(:id).all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @matches }
    end
  end

  # GET /matches/1
  # GET /matches/1.json
  def show
    authorize! :show, Match

    @match = Match.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @match }
    end
  end

  # GET /matches/1/edit
  def edit
    authorize! :edit, Match
    @match = Match.find(params[:id])
  end

  # POST /matches
  # POST /matches.json
  def create
    authorize! :create, Match

    @match = Match.new(match_params)

    respond_to do |format|
      if @match.save
        format.html { redirect_to @match, notice: 'Match was successfully created.' }
        format.json { render json: @match, status: :created, location: @match }
      else
        format.html { render action: "new" }
        format.json { render json: @match.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /matches/1
  # PATCH/PUT /matches/1.json
  def update
    authorize! :update, Match

    @match = Match.find(params[:id])

    respond_to do |format|
      if @match.update_attributes(match_params)
        UserMailer.match_played(@match.player1, @match.player2, @match).deliver
        UserMailer.match_played(@match.player2, @match.player1, @match).deliver
        format.html { redirect_to @match, notice: 'Match was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @match.errors, status: :unprocessable_entity }
      end
    end
  end

  def update_many
    authorize! :update, Match
    @tournament = Tournament.find(params[:tournament_id])
    if Match.update(params[:matches].keys, params[:matches].values)

      redirect_to @tournament, notice: 'Matches have been updated'
    else
      redirect_to @tournament, notice: 'There was a problem updating matches'
    end
  end

  def set_scores
    @match = Match.find(params[:id])
    if @match.update_attributes(match_params)
      UserMailer.match_played(@match.player1, @match.player2, @match).deliver
      UserMailer.match_played(@match.player2, @match.player1, @match).deliver
      render json: {update: true, html: @match.score}
    else
      render json: {update: false}
    end
  end

  private

    # Use this method to whitelist the permissible parameters. Example:
    # params.require(:person).permit(:name, :age)
    # Also, you can specialize this method with per-user checking of permissible attributes.
    def match_params
      authorize! :update, Match

      params.require(:match).permit(:player1_score, :player2_score)
    end
end
