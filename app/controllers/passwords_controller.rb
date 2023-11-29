class PasswordsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_password, except: [:index, :new, :create]
  before_action :require_editable_permission, only: [:edit, :update]
  before_action :require_deletable_permission, only: [:destroy]

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
    # The problem with previus code was that new create a password in memory but not the user so for this case create would join the password and the user creating both
    #@password = current_user.passwords.create(password_params)

    #another alternative is; 
    # @password = current_user.passwords.create(password_params)
    # @password.user_passwords.new(user: current_user)
    #if @password.save

    #if @password.save
    #also we cant use save since this generate error

    # code was working good line 21 but since we add a role we need to change to:
    @password = Password.new(password_params)
    @password.user_passwords.new(user: current_user, role: :owner)
    #if @password.persisted? commented because line 31
    if @password.save
      redirect_to @password
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit 
  end

  def update
    if @password.update(password_params)
      redirect_to @password
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @password.destroy
    redirect_to root_path
  end
  private

  def password_params
    params.require(:password).permit(:url, :username, :password)
  end

  def set_password
    @password = current_user.passwords.find(params[:id])
    #optimize query
    #@user_password = current_user.user_passwords.find_by(password: @password)
  end

  def require_editable_permission
    #query optimization
    #redirect_to @password unless @password.editable_by?(current_user)
    #optimized again but this time from application controller
    redirect_to @password unless current_user_password.editable?
  end

  def require_deletable_permission
    #optimized again but this time from application controller
    redirect_to @password unless current_user_password.deletable?
  end
end