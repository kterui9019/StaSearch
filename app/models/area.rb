class Area < ApplicationRecord
  has_many :studios
  validates :name, presence: true
end
