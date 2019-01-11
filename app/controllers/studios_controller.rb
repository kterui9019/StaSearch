class StudiosController < ApplicationController
  before_action :log_in_user, only:[:create, :new, :edit, :update, :destroy]

  # get /studios
  def index
    @q = Studio.search(search_params)
    @studios = @q.result.includes(:hash_tags, :hash_tag_relationships, :reviews).paginate(page: params[:page], per_page: 9)
  end
  
  def search
=begin
    @q = Studio.search(search_params)
    @areas = Area.all
    @hash_tags = HashTag.all
=end
    @q = Studio.search(search_params)
    @studios = @q.result.includes(:hash_tags, :hash_tag_relationships, :reviews).paginate(page: params[:page], per_page: 9)
  end
  
  # post /studios
  def create
    @studio = Studio.new(studio_params)
    @studio.created_user_id = @current_user.id
    if @studio.save
      @studio.regist_hash_tag(params[:studio][:hash_tags])
      flash[:success] = "スタジオの登録に成功しました！"
      redirect_to studio_path(@studio)
    else
      flash.now[:danger] = "スタジオの登録に失敗しました。"
      render 'new'
    end
  end
  
  # get /studios/new
  def new
    @studio = Studio.new
    @hash_tags = HashTag.all
  end
  
  # get /studios/:id/edit
  def edit
    @studio = Studio.find(params[:id])
  end
  
  # get /studios/:id
  def show
    @favorite = Favorite.new 
    @studio = Studio.find(params[:id])
    @hash_tags = @studio.hash_tags
    @reviews   = @studio.reviews.paginate(page: params[:page], per_page: 2)
  end

  # patch /studios/:id
  def update
    @studio = Studio.find(params[:id])
    @studio.update_attributes(studio_params)
    if @studio.save
      flash[:success] = "スタジオの編集に成功しました！"
      redirect_to studio_path(@studio)
    else
      flash[:danger] = "スタジオの編集に失敗しました。"
      render 'edit'
    end
  end
  
  # delete /studios/:id
  def destroy
    Studio.find(params[:id]).destroy
    redirect_to studios_path
  end
  
  private
    def search_params
      #params.require(:q).permit(:hash_tags_id_in => [], groupings: [:name_or_address_cont])
      params.require(:q).permit!

    end
  
    def studio_params
      params.require(:studio).permit(:name,
                                     :address,
                                     :image,
                                     :telno,
                                     :url,
                                     :latitude,
                                     :longitude)
    end
  
end
