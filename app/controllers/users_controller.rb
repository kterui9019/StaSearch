class UsersController < ApplicationController
  before_action :require_login
  
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to root_path
    else
      render :new
    end
  end
  
  def show
    @user = User.find(params[:id])
  end
  
  def edit
    @user = User.find(params[:id])
  end
  
  def update
  end
  
  def destroy
    User.find(params[:id]).destroy
  end
  
  private
  
    def user_params
      params.require(:user).permit(
        :email,
        :password,
        :password_confirmation
        )  
    end
  
  protected

    def not_authenticated
      redirect_to login_path
    end

end
