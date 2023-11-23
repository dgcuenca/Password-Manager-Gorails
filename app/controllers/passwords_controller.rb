class PasswordsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_password, except: [:index, :new, :create]

  def index
    @passwords = current_user.passwords
  end

  def show
  end

  def new
    @password = Password.new
  end

  def create
    #We use that association and this tell rails when instanciate this new password in memory It will automatically
    #have the join table automatically set up for us 
    #@password = current_user.passwords.new(password_params)
    # The problem with previus code was that new create a password in memory but then the join table desapeer so for this case create would join the password and the user
    @password = current_user.passwords.create(password_params)
    #if @password.save
    #also we cant use save since this generate error 
    if @password.persisted?
      redirect_to @password
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def password_params
    params.require(:password).permit(:url, :username, :password)
  end

  def set_password
    @password = current_user.passwords.find(params[:id])
  end
end