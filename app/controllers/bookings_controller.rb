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
  # 코드리뷰 이후 개선된 코드
  def update

    # 동일 클래스 내부이면 instance variable 사용하지 않는다.
    # 아래 user 객체는 택시기사 객체이다.
    user = User.find_by(driver_params[:taxi])

    # 해당 택시기사가 애초에 없는 택시기사일 때 에러메시지
    return error_message_response('This taxi driver is not exist') if user.nil? || user.usertype != 'driver'

    # 위의 택시기사가 이미 booking이 있는지 체크하기 위해 객체를 가져온다
    @booking = Booking.find_by(taxi: driver_params[:taxi]) # 동일 클래스 내부이면 instance variable 사용하지 않는다.

    # 택시기사가 이미 맡은 배차가 있을 때
    return error_message_response('This taxi driver already have booking') if @booking.present?

    return error_message_response('...', @booking.errors) unless accept_booking

    success_response

  end

  def accept_booking
    booking = Booking.find_by(id: params[:id])
    booking.taxi = driver_params[:taxi]
    booking.status = 'accepted'
    booking.save
  end

  def error_message_response(message, errors = nil)
    render(json: {
        message: message,
        errors: errors
    })
  end

  def success_response
    render :show, status: :ok, location: @booking
  end

  # 내가 처음에 작성한 Update 함수
=begin
  def update
    @user = User.find_by_id(driver_params[:taxi])
    @booking = Booking.find_by_taxi(@user.id)

    if !(@user.nil?) && @user.usertype == "driver"
      if @booking.nil?
        #if @booking.update(booking_params)
        #  render :show, status: :ok, location: @booking
        #else
        # render json: @booking.errors, status: :unprocessable_entity
        #end

        #@booking.update_attribute(:taxi, driver_params[:taxi])
        #@booking.update_attribute(:status, "accepted")
        #@booking.update_attribute(:updated_at, Time.now)
        taxi= driver_params[:taxi]
        status= "accepted"
        updated_at = Time.now

        # @booking.update(taxi: driver_params[:taxi], status: "accepted", updated_at: Time.now)
      else
        @msg = {
            message: "This taxi driver already have booking"
        }
        render json: @msg
      end

    else
      @msg = {
          message: "This taxi driver is not exist"
      }
      render json: @msg
    end
  end
=end

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
      # params.require(:booking).permit(:destination, :user_id)
      # 파라메터 이름 변경 : :taxi -> :driver_id
      params.require(:booking).permit(:destination, :status, :taxi, :created_at, :updated_at, :user_id)
    end

    def driver_params
      params.require(:booking).permit(:taxi, :user_id)
    end
end
