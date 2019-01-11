class ReviewsController < ApplicationController
  before_action :log_in_user
  
  def new
    @review = Review.new
    @studio = Studio.find(params[:studio_id])
  end
  
  def create
    review = Review.new(review_params)
    review.user_id = current_user.id
    if review.save
      review_relationship = ReviewRelationship.new(review_id: review.id, studio_id: params[:studio_id])
      review_relationship.save
      flash[:success] = "レビューを投稿しました。"
      redirect_to studio_path(params[:studio_id])
    else
      flash.now[:danger] = "レビューの投稿に失敗しました。"
      render 'new'
    end
  end
  
  private
  
    def review_params
      params.require(:review).permit(:title, :review, :rate)  
    end
end
