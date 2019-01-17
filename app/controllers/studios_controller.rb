class StudiosController < ApplicationController
  before_action :log_in_user, only:[:create, :new, :edit, :update, :destroy]

  # get /studios
  def index
    @q = Studio.search(search_params)
    @q_studios = @q.result(distinct: true).includes(:hash_tags, :hash_tag_relationships, :reviews, :accesses, :weekday_fee).paginate(page: params[:page], per_page: 9)
  end

  # post /studios
  def create
    #debugger
    @studio = Studio.new(studio_params)
    @studio.created_user_id = @current_user.id
    geocode(@studio)
    save_photo(@studio) if @studio.image.blank?
    #debugger
    if @studio.save
      create_access(@studio)
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
    @hash_tags = @studio.hash_tags
  end
  
  # get /studios/:id
  def show
    @favorite = Favorite.new 
    @studio = Studio.find(params[:id])
    @hash_tags = @studio.hash_tags
    @reviews   = @studio.reviews.includes(:user).paginate(page: params[:page], per_page: 2)
  end

  # patch /studios/:id
  def update
    @studio = Studio.find(params[:id])
    @studio.assign_attributes(studio_params)
    geocode(@studio)
    save_photo(@studio)
      if @studio.access.nil?
        create_access(@studio)
      else
        update_access(@studio)
      end
    if @studio.save
      flash[:success] = "スタジオの編集に成功しました。"
      redirect_to studio_path(@studio)
    else
      flash.now[:danger] = "スタジオの編集に失敗しました。"
      render 'edit'
    end
  end
  
  # delete /studios/:id
  def destroy
    Studio.find(params[:id]).destroy
    flash[:success] = "スタジオの削除に成功しました。"
    redirect_to user_path(current_user)
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
                                     :longitude,
                                     :opening_hours,
                                     :weekday_fee_id,
                                     :holiday_fee_id,
                                     {:hash_tag_ids => []}
                                     )
    end
    
    def geocode(studio)
      uri = URI.escape("https://maps.googleapis.com/maps/api/geocode/json?address="+studio.address.gsub(" ", "")+"&key=#{ENV['GOOGLEMAPS_IP_KEY']}")
      res = HTTP.get(uri).to_s
      response = JSON.parse(res)
      studio.place_id  = response["results"][0]["place_id"]
      studio.latitude  = response["results"][0]["geometry"]["location"]["lat"]
      studio.longitude = response["results"][0]["geometry"]["location"]["lng"]
    end
    
    def save_photo(studio)
      uri = URI.parse URI.encode "https://maps.googleapis.com/maps/api/place/details/json?placeid=#{studio.place_id}&key=#{ENV['GOOGLEMAPS_IP_KEY']}"
      res = HTTP.get(uri).to_s
      response = JSON.parse(res)
      result = response["result"]
      if result&.has_key?("photos")
        photo_reference = result['photos'][0]['photo_reference'] 
        url = "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&maxheight=400&photoreference=#{photo_reference}&key=#{ENV['GOOGLEMAPS_IP_KEY']}"
        studio.remote_image_url = url
      end
    end
    
    def create_access(studio)
      x = studio.longitude.to_f
      y = studio.latitude.to_f
      access_uri = URI.parse URI.encode "http://map.simpleapi.net/stationapi?x=#{x}&y=#{y}&output=json"
      access_res = HTTP.get(access_uri).to_s
      access_response = JSON.parse(access_res)
      access = Access.new(
        name: access_response[0]["name"],
        line: access_response[0]["line"],
        distanceKm: access_response[0]["distanceKm"],
        traveltime: access_response[0]["traveltime"],
        studio_id: studio.id
        )
      access&.save
    end
    
    def update_access(studio)
      x = studio.longitude.to_f
      y = studio.latitude.to_f
      access_uri = URI.parse URI.encode "http://map.simpleapi.net/stationapi?x=#{x}&y=#{y}&output=json"
      access_res = HTTP.get(access_uri).to_s
      access_response = JSON.parse(access_res)
      studio.access&.update_attributes(
        name: access_response[0]["name"],
        line: access_response[0]["line"],
        distanceKm: access_response[0]["distanceKm"],
        traveltime: access_response[0]["traveltime"],
        studio_id: studio.id
      )
    end
end
