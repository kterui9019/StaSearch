class AddRemarksToStudios < ActiveRecord::Migration[5.2]
  def change
    add_column :studios, :remarks, :string
  end
end
