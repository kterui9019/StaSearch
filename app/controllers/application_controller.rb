class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper
  before_action :set_search_query
  
  def set_search_query
    @q = Studio.ransack(params[:q])
    @areas = Area.all
    @hash_tags = HashTag.all
  end
  
  private
    def log_in_user
      unless logged_in?
        flash[:danger] = "ログインしてください。"
        redirect_to login_path
      end
    end
end
