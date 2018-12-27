class StaticPagesController < ApplicationController
  def home
    @favorite = Favorite.new
    @studios  = Studio.limit(4).order("created_at DESC")
  end
end