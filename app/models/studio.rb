class Studio < ApplicationRecord
  #エリア
  belongs_to :area
  #作ったユーザとのアソシエーション studio.created_user.name といった形で呼び出せる
  belongs_to :created_user, class_name: "User", optional: true
  #お気に入り
  has_many :favorites
  has_many :favorited_users, through: :favorites, source: :user
  #ハッシュタグ
  has_many :hash_tag_relationships
  has_many :hash_tags, through: :hash_tag_relationships
  #レビュー
  has_many :review_relationships
  has_many :reviews, through: :review_relationships

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

  def regist_hash_tag(hash_tag_ids)
    hash_tag_ids.each do |hash_tag_id|
      hash_tag = HashTagRelationship.new(studio_id: self.id, hash_tag_id: hash_tag_id)
      hash_tag.save
    end
  end
end