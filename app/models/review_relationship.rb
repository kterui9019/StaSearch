class ReviewRelationship < ApplicationRecord
  belongs_to :studio, optional: true
  belongs_to :review, optional: true
  
  validates :studio_id, presence: true
  validates :review_id, presence: true
end
