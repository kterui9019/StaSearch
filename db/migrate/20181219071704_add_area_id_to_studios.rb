class AddAreaIdToStudios < ActiveRecord::Migration[5.2]
  def change
    add_column :studios, :area_id, :integer
  end
end
