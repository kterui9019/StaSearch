class Studio < ApplicationRecord
  #エリア
  belongs_to :area
  #作ったユーザ
  belongs_to :user, optional: true
  #お気に入り
  has_many :favorites
  #カラムの名前をmount_uploaderに指定
  mount_uploader :image, ImageUploader
  
  validates :name, presence: true
  #validates :address, presence: true
  validates :area_id, presence: true
  
  def self.search_by_name(name)
    Studio.where('name LIKE ?',"%#{name}%")
  end
  
  def self.search_by_area(id)
    Studio.where('area_id = ?',"#{id.to_i}")
  end
  
  def favorite_id(user_id)
    favorite = Favorite.find_by(studio_id: self.id, user_id: user_id)
    favorite.id
  end
  
end