class AddImageToStudios < ActiveRecord::Migration[5.2]
  def change
    add_column :studios, :image, :string
  end
end
