class CreateAccesses < ActiveRecord::Migration[5.2]
  def change
    create_table :accesses do |t|
      t.string :name
      t.string :line
      t.string :distanceKm
      t.string :traveltime
      t.integer :studio_id

      t.timestamps
    end
  end
end
