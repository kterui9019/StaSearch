class HashTag < ApplicationRecord
  has_many :hash_tag_relationships
  has_many :studios, through: :hash_tag_relationships
  validates :tag, presence: true
end
