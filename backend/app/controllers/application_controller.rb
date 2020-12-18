class ApplicationController < ActionController::API
  include ActionController::Cookies

  before_action :check_is_logged_in

  def check_is_logged_in
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user&.authenticated?(cookies[:remember_token])
        session[:user_id] = user.id
        @current_user = user
      end
    end
  end
end
