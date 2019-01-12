class HashTagRelationship < ApplicationRecord
  belongs_to :studio, optional: true
  belongs_to :hash_tag, optional: true
  
  validates :studio_id, presence: true
  validates :hash_tag_id, presence: true
end
