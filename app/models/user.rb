class User < ApplicationRecord
  attr_accessor :remember_token
  before_save {email.downcase! }
  validates :name, presence: true
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }

  has_secure_password
  validates :password, presence: true
  #カラムの名前をmount_uploaderに指定
  THUMBNAIL_SIZE = [100, 100]
  mount_uploader :image, ImageUploader
  #作ったスタジオ user.create_studiosで呼び出せる
  #(class_nameは子のクラス名を指定、foreign_keyは子が親を呼び出すための外部キーカラム名)
  has_many :create_studios, class_name: "Studio", foreign_key: 'created_user_id'
  #お気に入り 以下のhas_manyを逆にするとエラーになる
  has_many :favorites
  has_many :favorite_studios, through: :favorites, source: :studio
  #レビュー
  has_many :reviews, dependent: :destroy
  

  #トークンを生成するメソッド
  def self.new_token
    SecureRandom.urlsafe_base64
  end
  
  #引数の文字列のダイジェストを返すメソッド
  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
  
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end
  
  def forget
    update_attribute(:remember_digest, nil)
  end
  
  #引数のトークンがremember_digestとあっているか？を認証するメソッド
  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end
end