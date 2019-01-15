class RemoveOpenFromStudios < ActiveRecord::Migration[5.2]
  def change
    remove_column :studios, :open, :string
  end
end
