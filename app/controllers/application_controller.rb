class ApplicationController < ActionController::Base
  rescue_from ActiveRecord::RecordNotFound do |exception|
    render json: { message: exception.message }, status: 404
  end
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session
  helper_method :mobile_browser?
  skip_before_action :verify_authenticity_token, if: :json_request?

  private

  def authenticate_user!
    if mobile_browser?
      authenticate_user_by_token
    else
      super
    end
  end

  def authenticate_user_by_token
    authenticate_by_token || access_denied
  end

  def access_denied
    remove_token_from_redis(user_auth_token) if mobile_browser?
    render json: 'Unauthorized', status: 401
  end

  def authenticate_by_token
    session_exist? && (token = user_auth_token) && (user_id = User.id_from_authentication_token(token)) && find_active_user(user_id)
  end

  def session_exist?
    session && session[:token] == user_auth_token
  end

  def user_auth_token
    request.headers['HTTP_AUTH_TOKEN']
  end

  def mobile_browser?
    request.user_agent =~ /Mobile|webOS/
  end

  def remove_token_from_redis(token)
    REDIS.del(token_key(token))
  end

  def token_key(token)
    User.auth_token_key(token)
  end

  def json_request?
    request.format.json?
  end

  def find_active_user(user_id)
    User.active.confirmed.find_by(id: user_id)
  end

  def set_locale
    I18n.locale = params[:locale] || I18n.config.default_locale
  end

  def convert_hash_keys(params)
    case params
      when Array
        params.map { |v| convert_hash_keys(v) }
      when Hash
        Hash[params.map { |k, v| [k.underscore.to_sym, convert_hash_keys(v)] }]
      else
        params
    end
  end

end
