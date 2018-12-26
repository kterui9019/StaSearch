class AddCreatedUserIdToStudios < ActiveRecord::Migration[5.2]
  def change
    add_column :studios, :created_user_id, :integer
  end
end
