class FavoritesController < ApplicationController
  before_action :log_in_user
  
  def create
    @studio = Studio.find(params[:studio_id])
    favorite = Favorite.new(user_id: @current_user.id, studio_id: @studio.id)
    if favorite.save
      #flash[:success] = "お気に入りに追加しました。"
      respond_to do |format|
        format.html { redirect_to @studio }
        format.js
      end
    else
      render studios_path
    end
  end
  
  def destroy
    @studio = Studio.find(params[:studio_id])
    Favorite.find_by(params[:id]).destroy
    respond_to do |format|
      format.html { redirect_to @studio }
      format.js
    end
  end
end