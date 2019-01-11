class UsersController < ApplicationController
  before_action :log_in_user, only:[:show, :edit, :update, :destroy]

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
    @studios = @user.favorite_studios.includes(:hash_tags, :hash_tag_relationships, :reviews, :access).paginate(page: params[:page], per_page: 6)
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
