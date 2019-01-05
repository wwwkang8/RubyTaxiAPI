class Booking < ApplicationRecord
  belongs_to :user

  # controller   @booking=find(booking_id)  @booking.accept

  def accept(driver)
    self.update()
  end
end
