class ApplicationController < ActionController::Base

  helper_method :current_user
  before_action :prepare_id_param

  def render_errors(status, errors)
    render json: { errors: errors }, status: status
  end

  def authorize!
    return true if current_user.authorized
    render_errors(403, { invalid_auth_key: "Invalid auth key." }) and return false
  end

  private

  def current_user
    auth_key = params[:auth_key] || session[:auth_key] || request.headers["User-Auth-Key"]
    @current_user ||= User.find_by_auth_key(auth_key)
  end

  def prepare_id_param
    params[:id] = params[:id].to_i if params[:id].present?
  end

end
