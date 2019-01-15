class StaticPagesController < ApplicationController

  def home
    @new_studios  = Studio.limit(4).order("created_at DESC").includes(:hash_tag_relationships, :hash_tags, :access, :reviews, :weekday_fee)
  end
end