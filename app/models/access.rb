class Access < ApplicationRecord
  belongs_to :studio
=begin
  validates :name, presence: true
  validates :line, presence: true
  validates :distanceKm, presence: true
  validates :traveltime, presence: true
=end
  validates :studio_id, presence: true
end
