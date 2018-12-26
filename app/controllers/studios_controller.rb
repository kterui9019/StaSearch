class StudiosController < ApplicationController
  
  # get /studios
  def index
    if params[:search_name]
      @studios = Studio.search_by_name(params[:search_name])
    else params[:search_area]
      @studios = Studio.search_by_area(params[:search_area])
    end
  end
  
  # post /studios
  def create
    @studio = Studio.new(studio_params)
    if @studio.save
      flash[:success] = "スタジオの登録に成功しました！"
      redirect_to studios_path
    else
      flash.now[:danger] = "スタジオの登録に失敗しました。"
      render 'new'
    end
  end
  
  # get /studios/new
  def new
    @studio = Studio.new
  end
  
  # get /studios/:id/edit
  def edit
    @studio = Studio.find(params[:id])
  end
  
  # get /studios/:id
  def show
    @studio = Studio.find(params[:id])
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
  
  def studio_params
    params.require(:studio).permit(:name,
                                   :address,
                                   :area_id,
                                   :image)
  end
  
end
