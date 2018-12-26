class AddUrlToStudios < ActiveRecord::Migration[5.2]
  def change
    add_column :studios, :url, :string
  end
end
