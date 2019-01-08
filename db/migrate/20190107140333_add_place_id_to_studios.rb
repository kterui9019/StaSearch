class AddPlaceIdToStudios < ActiveRecord::Migration[5.2]
  def change
    add_column :studios, :place_id, :string
  end
end
