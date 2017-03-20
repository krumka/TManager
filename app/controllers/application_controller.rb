class ApplicationController < ActionController::Base
  #rescue_from Exception,
  #            :with => :render_error
  rescue_from ActionController::RoutingError,
              :with => :render_not_found
  rescue_from ActionController::UnknownController,
              :with => :render_not_found
  rescue_from AbstractController::ActionNotFound,
              :with => :render_not_found
  rescue_from ActiveRecord::RecordNotFound,
              :with => :render_not_found
  rescue_from CanCan::AccessDenied do |exception|
    if !Rails.env.development?
      render "errors/unauthorized"
    end
  end
  before_filter :ensure_signup_complete, only: [:new, :create, :update, :destroy]

  def render_not_found(exception)
    if !Rails.env.development?
      render  "errors/404", :status => 404
    end
  end
  def routing_error
    if !Rails.env.development?
      render "errors/404route", :status => 404
    end
  end

  def render_error(exception)
    if !Rails.env.development?
      render "errors/500", :status => 500
    end
  end
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
