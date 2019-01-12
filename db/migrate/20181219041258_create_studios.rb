class CreateStudios < ActiveRecord::Migration[5.2]
  def change
    create_table :studios do |t|
      t.string :name
      t.string :address
      t.decimal :latitude, :precision => 12, :scale => 9
      t.decimal :longitude, :precision => 12, :scale => 9
      t.timestamps
    end
  end
end
