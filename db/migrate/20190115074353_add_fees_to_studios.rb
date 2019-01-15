class AddFeesToStudios < ActiveRecord::Migration[5.2]
  def change
    add_column :studios, :weekday_fee_id, :integer
    add_column :studios, :holiday_fee_id, :integer
  end
end
