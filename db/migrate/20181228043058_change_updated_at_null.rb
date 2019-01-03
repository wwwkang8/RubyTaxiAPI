class ChangeUpdatedAtNull < ActiveRecord::Migration[5.2]
  def change
    change_column :bookings, :updated_at, :datetime
    change_column :bookings, :taxi, :integer, :null => true
  end
end
