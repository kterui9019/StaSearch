class Studio < ApplicationRecord
  #作ったユーザとのアソシエーション studio.created_user.name といった形で呼び出せる
  belongs_to :created_user, class_name: "User", optional: true
  #お気に入り
  has_many :favorites, dependent: :destroy
  has_many :favorited_users, through: :favorites, source: :user, dependent: :destroy
  #ハッシュタグ
  has_many :hash_tag_relationships, dependent: :destroy
  has_many :hash_tags, through: :hash_tag_relationships
  #レビュー
  has_many :review_relationships, dependent: :destroy
  has_many :reviews, through: :review_relationships, dependent: :destroy
  #アクセス
  has_many :accesses, dependent: :destroy
  #料金
  belongs_to :weekday_fee, class_name: "Fee", optional: true
  belongs_to :holiday_fee, class_name: "Fee", optional: true
  
  #カラムの名前をmount_uploaderに指定
  #THUMBNAIL_SIZE = [300, 250]
  mount_uploader :image, ImageUploader
  
  validates :name, presence: true, length: { maximum: 50 }
  validates :address, presence: true, length: { maximum: 100 }
  validates :created_user_id, presence: true
  validates :place_id, uniqueness: true
=begin
  VALID_TELNO_REGEX = /\A(((0(\d{1}[-(]?\d{4}|\d{2}[-(]?\d{3}|\d{3}[-(]?\d{2}|\d{4}[-(]?\d{1}|[5789]0[-(]?\d{4})[-)]?)|\d{1,4}\-?)\d{4}|0120[-(]?\d{3}[-)]?\d{3})\z/
  VALID_URL_REGEX = /\A#{URI::regexp(%w(http https))}\z/
  validates :telno, format: { with: VALID_TELNO_REGEX }, allow_nil: true
=end

  
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