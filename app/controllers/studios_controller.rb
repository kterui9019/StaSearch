class StudiosController < ApplicationController
  before_action :log_in_user, only:[:create, :new, :edit, :update, :destroy]

  # get /studios
  def index
    @q = Studio.ransack(params[:q])
    @areas = Area.all
    @hash_tags = HashTag.all
    #@studios = @query.result(distinct: true).paginate(page: params[:page], per_page: 9)
    @studios = @q.result.includes(:hash_tags, :hash_tag_relationships, :reviews, :review_relationships).paginate(page: params[:page], per_page: 9)

=begin
    if params[:search_name]
      @studios = Studio.where('name LIKE ?',"%#{params[:search_name]}%").paginate(page: params[:page], per_page: 9)
      #@studios = Studio.paginate(:page => params[:page])
    elsif params[:search_area]
      @studios = Studio.where('area_id = ?',"#{params[:search_area].to_i}").paginate(page: params[:page], per_page: 9)
      #@studios = Studio.paginate(:page => params[:page])
    end
=end
  end
  
  def search
    @q = Studio.search(search_params)
    @areas = Area.all
    @hash_tags = HashTag.all
    @studios = @q.result.includes(:hash_tags, :hash_tag_relationships, :reviews, :review_relationships).paginate(page: params[:page], per_page: 9)
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
    @reviews   = @studio.reviews
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
      params.require(:q).permit(:name_cont,
                                :area_id_eq,
                                :hash_tag_id_in)
    end
  
    def studio_params
      params.require(:studio).permit(:name,
                                     :address,
                                     :area_id,
                                     :image,
                                     :telno,
                                     :url,
                                     :latitude,
                                     :longitude)
    end
  
end
