class RemoveFeeIdFromStudios < ActiveRecord::Migration[5.2]
  def change
    remove_column :studios, :fee_id, :integer
  end
end
