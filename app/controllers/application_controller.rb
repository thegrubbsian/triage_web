class ApplicationController < ActionController::Base

  helper_method :current_user
  before_action :prepare_id_param

  unless Rails.env.production?
    before_action :cors_check
    after_action :set_access_control_headers
  end

  def render_errors(status, errors)
    render json: { errors: errors }, status: status
  end

  def authorize!
    return true if current_user.authorized
    render_errors(403, { invalid_auth_key: "Invalid auth key." }) and return false
  end

  private

  def current_user
    auth_key = request.headers["auth_key"] || params[:auth_key]
    @current_user ||= User.find_by_auth_key(auth_key)
  end

  def prepare_id_param
    params[:id] = params[:id].to_i if params[:id].present?
  end

  def set_access_control_headers
    headers["Access-Control-Allow-Origin"] = "*"
    headers["Access-Control-Allow-Methods"] = "POST, GET, OPTIONS"
    headers["Access-Control-Max-Age"] = "1728000"
  end

  def cors_check
    return unless request.method == :options
    headers["Access-Control-Allow-Origin"] = "*"
    headers["Access-Control-Allow-Methods"] = "POST, GET, OPTIONS"
    headers["Access-Control-Allow-Headers"] = "X-Requested-With, X-Prototype-Version"
    headers["Access-Control-Max-Age"] = "1728000"
    render :text => "", :content_type => "text/plain"
  end

end
