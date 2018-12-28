class CreateBookings < ActiveRecord::Migration[5.2]
  def change
    create_table :bookings do |t|
      t.string :destination
      t.string :status
      t.integer :taxi, :null => true
      t.datetime :created_at
      t.datetime :updated_at
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
