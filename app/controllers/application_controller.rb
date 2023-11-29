class ApplicationController < ActionController::Base
  def current_user_password
    # _ after the @ helps to not accidentally overwrited 
    @_current_user_password ||= current_user.user_passwords.find_by(password: @password)
  end
  #expose helper method for views
  helper_method :current_user_password
end
