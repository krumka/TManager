class UsersController < ApplicationController
  before_filter :set_user, only: [:show, :edit, :update, :destroy, :finish_signup]

  respond_to :html

  def index
    authorize! :index, User

    @users = User.all
    respond_with(@users)
  end

  def show
    @user = User.find(params[:id])
    if @user.lat.nil? || @user.lon.nil?
      @user.geocode
    end
    @subscriptions = @user.programs
    @matches = Match.where("player1_id = ? OR player2_id = ?", @user.id, @user.id).order(:program_id)
  end

  def new
    authorize! :create, User

    @user = User.new
    respond_with(@user)
  end

  def edit
    authorize! :update, @user

  end

  def create
    authorize! :create, User

    @user = User.new(params[:user])
    @user.save
    respond_with(@user)
  end

  def update
    authorize! :update, @user

    # authorize! :update, @user
    @user.username = params[:user][:username].downcase.camelize
    @user.name = params[:user][:name].downcase.camelize
    @user.firstname = params[:user][:firstname].downcase.camelize
    @user.adress = params[:user][:adress].downcase.camelize
    @user.zip_code = params[:user][:zip_code]
    @user.city = params[:user][:city].downcase.camelize
    @user.country = params[:user][:country].downcase.camelize
    @user.geocode
    @user.image = params[:user][:image]
    if params[:user][:role]
      @user.role = params[:user][:role]
    end
    @user.birthdate = Date.new(params[:user]["birthdate(1i)"].to_i, params[:user]["birthdate(2i)"].to_i, params[:user]["birthdate(3i)"].to_i)
    respond_to do |format|
      if @user.update_attributes(user_params)
        sign_in(@user == current_user ? @user : current_user, :bypass => true)
        format.html { redirect_to @user, notice: 'Your profile was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    authorize! :destroy, @user

    @user.destroy
    respond_to do |format|
      format.html { redirect_to root_url }
      format.json { head :no_content }
    end
  end

  def finish_signup
    authorize! :update, @user

    if request.put? && params[:user] #&& params[:user][:email]
      if @user.update_attributes(email: params[:user][:email])
        @user.skip_reconfirmation!
        sign_in(@user, :bypass => true)
        redirect_to @user, notice: 'Your profile was successfully updated.'
      else
        @show_errors = true
      end
    end
  end

  def subscribe
    if current_user
      @tournament = Tournament.find(params[:tournament_id])
      if @tournament.users.uniq.size < @tournament.max_gamers
        if (@tournament.date - 2.days) < DateTime.now
          redirect_to @tournament, notice: 'The subscriptions for this tournament are over'
        else
          if !current_user.programs.where(tournament_id: params[:tournament_id]).where(game_id: params[:game_id]).exists?
            current_user.programs << Program.where(tournament_id: params[:tournament_id]).where(game_id: params[:game_id])
            UserMailer.subscribe_tournament(@tournament, Game.find(params[:game_id]), current_user).deliver
            redirect_to @tournament, notice: 'You successfully subscribed to ' + Game.find(params[:game_id]).name + ' on ' + Tournament.find(params[:tournament_id]).name + ' tournament.'
          else
            redirect_to @tournament, notice: 'You already subscribed to ' + Game.find(params[:game_id]).name + ' on ' + Tournament.find(params[:tournament_id]).name + ' tournament.'
          end
        end
      else
        redirect_to @tournament, notice: 'The subscriptions for this tournament are full'
      end
    else
      redirect_to @tournament, notice: 'You have to connect first'
    end
  end

  def unsubscribe
    if current_user
      @tournament = Tournament.find(params[:tournament_id])
      if (@tournament.date - 2.days) < DateTime.now
        redirect_to @tournament, notice: 'The subscriptions for this tournament are over'
      else
        if current_user.programs.where(tournament_id: params[:tournament_id]).where(game_id: params[:game_id]).exists?
          current_user.programs.delete(Program.where(tournament_id: params[:tournament_id]).where(game_id: params[:game_id]))
          redirect_to @tournament, notice: 'You successfully unsubscribed to ' + Game.find(params[:game_id]).name + ' on ' + Tournament.find(params[:tournament_id]).name + ' tournament.'
        else
          redirect_to @tournament, notice: 'You already unsubscribed to ' + Game.find(params[:game_id]).name + ' on ' + Tournament.find(params[:tournament_id]).name + ' tournament.'
        end
      end
    else
      redirect_to @tournament, notice: 'You have to connect first'
    end
  end

  def make_admin
    authorize! :update, User

    @user = User.find(params[:user_id])
    if @user.role == 1
      redirect_to users_path, notice: 'The user was already an administrator'
    else
      @user.role = 1
      @user.save
      redirect_to users_path, notice: 'The user was promoted as administrator'
    end
  end

  def unmake_admin
    authorize! :update, User

    @user = User.find(params[:user_id])
    if @user.role != 1
      redirect_to users_path, notice: "The user wasn't administrator yet"
    else
      @user.role = 0
      @user.save
      redirect_to users_path, notice: 'The user is not an administrator anymore'
    end
  end

  def calculate_points
    authorize! :subscribe, @user

    @user = User.find(params[:user_id])
    @user.calculate_points
    redirect_to @user, notice: 'The user\'s points has been updated '
  end

  def ranking
    @users = User.order("points DESC").where("points != 0")
  end

  def email_exists
    render json: { email: !User.where("email = ?", params[:email].downcase).empty? }
  end

  def username_exists
    render json: { username: !User.where("username = ?", params[:username].downcase.camelize).empty? }
  end

  private
    def set_user
      @user = User.find(params[:id])
      if request.params[:action] != "show"
        if current_user.role != 1 && current_user.id != @user.id
          if Rails.env.development?
            redirect_to root_path, :alert => "Error 401 - " + "Forbidden" +
                (current_user.role != 1).to_s +
                "\nAction : " + request.params[:action] +
                "\nController : " + request.params[:controller]
          else
            render "errors/unauthorized"
          end
        end
      end
    end

  def user_params
    authorize! :update, @user

    accessible = [ :email, :username, :firstname, :name, :adress, :country, :zip_code, :city ] # extend with your own params
    accessible << [ :password, :password_confirmation ] unless params[:user][:password].blank?
    params.require(:user).permit(accessible)
  end
end
