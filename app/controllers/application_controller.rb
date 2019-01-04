class ApplicationController < ActionController::Base
  include AbstractController::Translation

  protect_from_forgery unless: -> { request.format.json? }
  before_action :authenticate_user_from_token!

  respond_to :json

  #rescue_from StandardError,                  with: :render_500
  #rescue_from ActiveRecord::RecordInvalid,    with: :render_404
  #rescue_from ActionController::RoutingError, with: :render_404
  #rescue_from ActiveRecord::RecordNotFound,   with: :render_404

  def render_500
    redirect_to '/home'
  end

  def render_422
    redirect_to '/home'
  end

  def render_404
    redirect_to '/home'
  end

  ##
  # User Authentication
  # Authenticates the user with OAuth2 Resource Owner Password Credentials
  def authenticate_user_from_token!
    auth_token = request.headers['Authorization']

    if auth_token
      authenticate_with_auth_token auth_token
    else
      authenticate_error
    end
  end

  private

  def authenticate_with_auth_token auth_token
    unless auth_token.include?(':')
      authenticate_error
      return
    end

    user_id = auth_token.split(':').first
    @current_user = User.where(id: user_id).first

    if @current_user && Devise.secure_compare(@current_user.access_token, auth_token)
      sign_in @current_user, store: false
    else
      authenticate_error
    end
  end

  ##
  # Authentication Failure
  # Renders a 401 error
  def authenticate_error
    render json: { error: 'devise.failure.unauthenticated' }, status: 401
  end
end