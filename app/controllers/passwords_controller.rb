class PasswordsController < ApplicationController
  before_action :authenticate_user!

  def index
    @passwords = current_user.passwords
  end

  def new
    @password = Password.new
  end

  def create
    #We use that association and this tell rails when instanciate this new password in memory It will automatically
    #have the join table automatically set up for us
    @password = current_user.passwords.new(password_params)
    if @password.save
      redirect_to @password
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def password_params
    params.require(:password).permit(:url, :username, :password)
  end
end