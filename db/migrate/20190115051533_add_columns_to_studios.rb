class AddColumnsToStudios < ActiveRecord::Migration[5.2]
  def change
    add_column :studios, :open, :string
    add_column :studios, :close, :string
  end
end
