class User < ApplicationRecord
  attr_accessor :remember_token
  before_save {email.downcase! }
  validates :name, presence: true
  validates :email, presence: true, uniqueness: {case_sensitive: false}
  has_secure_password
  validates :password, presence: true
  
  
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