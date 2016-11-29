require "json_web_token"

class ApplicationController < ActionController::API
  include Concerns::Messages
  include Concerns::Response

  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  rescue_from ActionController::ParameterMissing, with: :missing_param_error

  attr_reader :current_user, :token

  def not_found
    render_response({ error: record_not_found }, :not_found)
  end

  def missing_param_error(exception)
    render_response({ error: exception.message }, :unprocessable_entity)
  end

  protected

  def authenticate_request!
    if !payload || !JsonWebToken.valid_payload(payload.first) ||
        !Authentication.validate_token(token)
      return invalid_authentication
    end
    set_current_user!
    invalid_authentication unless current_user
  end

  def invalid_authentication
    render_response({ error: invalid_request }, :unauthorized)
  end

  private

  def payload
    auth_header = request.headers["Authorization"]
    @token = auth_header.split(" ").last
    JsonWebToken.decode(token)
  rescue
    nil
  end

  def set_current_user!
    @current_user ||= User.find_by(id: payload[0]["user_id"])
  end
end
