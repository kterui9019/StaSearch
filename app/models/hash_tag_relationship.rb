class HashTagRelationship < ApplicationRecord
  belongs_to :studio, optional: true
  belongs_to :hash_tag, optional: true
end
