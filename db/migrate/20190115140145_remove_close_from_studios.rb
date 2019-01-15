class RemoveCloseFromStudios < ActiveRecord::Migration[5.2]
  def change
    remove_column :studios, :close, :string
  end
end
