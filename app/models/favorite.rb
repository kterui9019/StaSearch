class Favorite < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :studio, optional: true
  validates :user_id, presence: true
  validates :studio_id, presence: true
end
