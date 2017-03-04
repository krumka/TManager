class UsersController < ApplicationController
  before_filter :set_user, only: [:show, :edit, :update, :destroy, :finish_signup]

  respond_to :html

  def index
    @users = User.all
    respond_with(@users)
  end

  def show
    # authorize! :read, @user
    respond_with(@user)
  end

  def new
    @user = User.new
    respond_with(@user)
  end

  def edit
    # authorize! :update, @user
  end

  def create
    @user = User.new(params[:user])
    @user.save
    respond_with(@user)
  end

  def update
    # authorize! :update, @user
    @user.username = params[:user][:username]
    @user.name = params[:user][:name]
    @user.firstname = params[:user][:firstname]
    @user.adress = params[:user][:adress]
    @user.zip_code = params[:user][:zip_code]
    @user.city = params[:user][:city]
    @user.country = params[:user][:country]
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
    # authorize! :delete, @user
    @user.destroy
    respond_to do |format|
      format.html { redirect_to root_url }
      format.json { head :no_content }
    end
  end

  def finish_signup
    # authorize! :update, @user
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
    if !current_user.programs.where(tournament_id: params[:tournament_id]).where(game_id: params[:game_id]).exists?
      current_user.programs << Program.where(tournament_id: params[:tournament_id]).where(game_id: params[:game_id])
      redirect_to Tournament.find(params[:tournament_id]), notice: 'You successfully subscribed to ' + Game.find(params[:game_id]).name + ' on ' + Tournament.find(params[:tournament_id]).name + ' tournament.'
    else
      redirect_to Tournament.find(params[:tournament_id]), warning: 'You already subscribed to ' + Game.find(params[:game_id]).name + ' on ' + Tournament.find(params[:tournament_id]).name + ' tournament.'
    end
  end

  def unsubscribe
    if current_user.programs.where(tournament_id: params[:tournament_id]).where(game_id: params[:game_id]).exists?
      current_user.programs.delete(Program.where(tournament_id: params[:tournament_id]).where(game_id: params[:game_id]))
      redirect_to Tournament.find(params[:tournament_id]), notice: 'You successfully unsubscribed to ' + Game.find(params[:game_id]).name + ' on ' + Tournament.find(params[:tournament_id]).name + ' tournament.'
    else
      redirect_to Tournament.find(params[:tournament_id]), warning: 'You already unsubscribed to ' + Game.find(params[:game_id]).name + ' on ' + Tournament.find(params[:tournament_id]).name + ' tournament.'
    end
  end

  private
    def set_user
      @user = User.find(params[:id])
    end

  def user_params
    accessible = [ :email, :username, :firstname, :name, :adress, :country, :zip_code, :city ] # extend with your own params
    accessible << [ :password, :password_confirmation ] unless params[:user][:password].blank?
    params.require(:user).permit(accessible)
  end
end
