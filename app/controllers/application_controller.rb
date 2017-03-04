class ApplicationController < ActionController::Base
  before_filter :ensure_signup_complete, only: [:new, :create, :update, :destroy]

  def ensure_signup_complete
    # Ensure we don't go into an infinite loop
    return if action_name == 'finish_signup'

    # Redirect to the 'finish_signup' page if the user
    # email hasn't been verified yet
    if current_user && !current_user.email_verified?
      redirect_to edit_user_registration_path(current_user), danger: "Please, comfirm your email first."
    end
  end
end
