class CreateHashTagRelationships < ActiveRecord::Migration[5.2]
  def change
    create_table :hash_tag_relationships do |t|
      t.integer :studio_id
      t.integer :hash_tag_id

      t.timestamps
    end
  end
end
