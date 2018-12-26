class FavoritesController < ApplicationController
  before_action :log_in_user
  def create
    favorite = Favorite.new(user_id: @current_user.id, studio_id: params[:studio_id].to_i)
    if favorite.save
      flash[:success] = "お気に入りに追加しました。"
      redirect_to studio_path(Studio.find(favorite.studio_id))
    else
      flash.now[:danger] = "お気に入りの追加に失敗しました。"
      render studios_path
    end
  end
  
  def destroy
    Favorite.find(params[:id]).destroy
    redirect_to studios_path
  end
end