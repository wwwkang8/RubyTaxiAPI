class ChangeUpdatedAtNull < ActiveRecord::Migration[5.2]
  def change
    change_column :bookings, :updated_at, :datetime, :null => true
    change_column :bookings, :taxi, :integer, :null => true
  end
end
