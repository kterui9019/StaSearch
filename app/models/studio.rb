class Studio < ApplicationRecord
  #エリア
  belongs_to :area
  #作ったユーザ
  belongs_to :user, optional: true
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
  
end