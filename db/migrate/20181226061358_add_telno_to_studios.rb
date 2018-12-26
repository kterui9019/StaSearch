class AddTelnoToStudios < ActiveRecord::Migration[5.2]
  def change
    add_column :studios, :telno, :string
  end
end
