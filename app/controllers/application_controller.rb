class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper
  before_action :set_search_query
  
  def set_search_query
    @hash_tags = HashTag.all
    words = params[:q].delete(:name_or_address_cont) if params[:q].present?
    if words.present?
      params[:q][:groupings] = []
      words.split(/[ 　]/).each_with_index do |word, i| #全角空白と半角空白で切って、単語ごとに処理します
        params[:q][:groupings][i] = { name_or_address_cont: word }
      end
    end
    @q = Studio.ransack(params[:q])
    @studios = @q.result(distinct: true).includes(:hash_tags, :hash_tag_relationships, :reviews).paginate(page: params[:page], per_page: 9)
    
  end
  
  private
    def log_in_user
      unless logged_in?
        flash[:danger] = "ログインしてください。"
        redirect_to login_path
      end
    end
    
end
