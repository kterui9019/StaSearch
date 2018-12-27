class ReviewRelationship < ApplicationRecord
  belongs_to :studio, optional: true
  belongs_to :review, optional: true
end
