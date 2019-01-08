class StaticPagesController < ApplicationController

  def home
    @favorite = Favorite.new
    @new_studios  = Studio.limit(4).order("created_at DESC")
    
    @q = Studio.ransack(params[:q])
    @areas = Area.all
    @hash_tags = HashTag.all
    #@studios = @q.result.includes(:hash_tags, :hash_tag_relationships, :reviews, :review_relationships).paginate(page: params[:page], per_page: 9)

  end
end