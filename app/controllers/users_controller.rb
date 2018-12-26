class UsersController < ApplicationController

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "ユーザー登録に成功しました。"
      log_in @user
      redirect_to user_path(@user)
    else
      flash.now[:danger] = "ユーザー登録に失敗しました。"
      render :new
    end
  end
  
  def show
    @user = User.find(params[:id])
    @create_studios = Studio.where("created_user_id = #{@user.id.to_i}")
  end
  
  def edit
    @user = User.find(params[:id])
  end
  
  def update
    user = User.find(params[:id])
    if user
      flash[:success] = "プロフィール情報を更新しました。"
      user.update_attributes(user_params)
      redirect_to user
    else
      flash.now[:danger] = "プロフィール情報を更新できませんでした。"
      render "edit"
    end
  end
  
  def destroy
    User.find(params[:id]).destroy
    flash[:success] =   "退会処理が完了しました。"
    redirect_to root_path
  end
  
  private
  
    def user_params
      params.require(:user).permit(
        :name,
        :email,
        :password,
        :password_confirmation,
        :image
        )  
    end
    
end
