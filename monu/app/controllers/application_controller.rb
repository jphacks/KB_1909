class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Token::ControllerMethods

  def authenticate!
    authenticate_or_request_with_http_token do |token, options|
      User.find_by(token: token).present?
    end
  end

  def current_user
    @current_user ||= User.find_by(token: request.headers['Authorization'].split[1])
  end
end
