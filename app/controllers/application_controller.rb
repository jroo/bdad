# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  
  # protect_from_forgery # See ActionController::RequestForgeryProtection for details
  
  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  
  # @current_user ||= User.find(current_user_id)
  def current_user
    if @current_user
      @current_user
    else
      user = User.find(current_user_id)
      @current_user = if user
        user
      else
        reset_current_user_id!
        User.find(current_user_id)
      end
    end
  end
  
  protected
  
  def current_user_id
    session[:current_user_id] ||= User.create_random!.id
  end
  
  def reset_current_user_id!
    session[:current_user_id] = User.create_random!.id
  end
  
end
