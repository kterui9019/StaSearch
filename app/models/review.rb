class Review < ApplicationRecord
  #レビュー
  has_many :review_relationships
  has_many :studios, through: :review_relationships
  belongs_to :user
  validates :title, presence: true
  validates :review, presence: true
  validates :rate, presence: true
end
