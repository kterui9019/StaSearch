class Favorite < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :studio, optional: true
end
