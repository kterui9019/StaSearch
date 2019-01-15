class AddOpeningHoursToStudios < ActiveRecord::Migration[5.2]
  def change
    add_column :studios, :opening_hours, :string
  end
end
