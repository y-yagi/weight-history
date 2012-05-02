class ApplicationController < ActionController::Base
  protect_from_forgery 

  helper_method :current_user, :logged_in?
  private 
  def current_user
    @current_user ||= User.find(session[:uid]) if session[:uid]
  end 

  def logged_in?
    session[:uid] != nil
  end
end
