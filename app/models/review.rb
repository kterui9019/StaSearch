class Review < ApplicationRecord
  #レビュー
  has_many :review_relationships
  has_many :studios, through: :review_relationships
  belongs_to :user
end
