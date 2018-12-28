class BookingsController < ApplicationController
  before_action :set_booking, only: [:show, :update, :destroy]

  # GET /bookings
  # GET /bookings.json
  def index
    @bookings = Booking.all
  end

  # GET /bookings/1
  # GET /bookings/1.json
  def show
  end

  # POST /bookings
  # POST /bookings.json
  def create
    @booking = Booking.new(booking_params)
    if (booking_params[:destination]).length < 100
      if @booking.save
        render :show, status: :created, location: @booking
      else
        render json: @booking.errors, status: :unprocessable_entity
      end
    else
        @msg = {
          message: "Destination is too long. limit 100character. Please write shorter."
        }
      render json: @msg
    end

  end

  # PATCH/PUT /bookings/1
  # PATCH/PUT /bookings/1.json
  def update
    if @booking.update(booking_params)
      render :show, status: :ok, location: @booking
    else
      render json: @booking.errors, status: :unprocessable_entity
    end
  end

  # DELETE /bookings/1
  # DELETE /bookings/1.json
  def destroy
    @booking.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_booking
      @booking = Booking.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def booking_params
      # params.require(:booking).permit(:destination, :status, :taxi, :created_at, :updated_at, :user_id)
      params.require(:booking).permit(:destination, :user_id)
    end
end
