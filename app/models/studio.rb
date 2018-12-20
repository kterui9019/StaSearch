class Studio < ApplicationRecord
  belongs_to :area
  
  validates :name, presence: true
  #validates :address, presence: true
  validates :area_id, presence: true
  
  def self.search_by_name(name)
    Studio.where('name LIKE ?',"%#{name}%")
  end
  
  def self.search_by_area(id)
    Studio.where('area_id = ?',"#{id.to_i}")
  end
  
end