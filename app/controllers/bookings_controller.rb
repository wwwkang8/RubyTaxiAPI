class BookingsController < ApplicationController
  before_action :set_booking, only: [:show, :update, :destroy]

  # GET /bookings
  # GET /bookings.json
  def index
    @user = current_user
    @bookings = Booking.all.order(id: :desc)
  end

  # GET /bookings/1
  # GET /bookings/1.json
  def show

  end

  # POST /bookings
  # POST /bookings.json
  def create
    @booking = Booking.new(booking_params)
    if (booking_params[:destination]).length < 100 # 배차 신청시에 목적지의 글자가 100자 이내로 제한
      if @booking.save
        render :show, status: :created, location: @booking
      else
        render json: @booking.errors, status: :unprocessable_entity
      end
    else
      error_message_response('Destination is too long. limit 100character. Please write shorter.')
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

    # 해당 booking이 이미 다른 택시기사에게 배차 수락이 되었을때, 중복 수락을 방지하기 위한 코드
    @booking = Booking.find_by(id: params[:id])
    return error_message_response('This booking has been already accepted by other driver.') if @booking.taxi.present?

    # 위의 택시기사가 이미 booking이 있는지 체크하기 위해 객체를 가져온다
    # 만약 택시기사가 이전에 받았던 예약들이 많으면 List로 받아야 할텐데?
    @booking = Booking.find_by(taxi: driver_params[:taxi], status: 'accepted') # 동일 클래스 내부이면 instance variable 사용하지 않는다.

    # 해당 택시기사가 이미 수락한 배차 요청이 있을때(승객운송을 완료하지 않은 상태)
    return error_message_response('This taxi driver already have booking') if @booking.present? && @booking.status == 'accepted'

    return error_message_response('...', @booking.errors) unless accept_booking

    success_response

  end
  
  # 택시기사가 배차 수락을 했을 때
  def accept_booking
    booking = Booking.find_by(id: params[:id])
    booking.taxi = driver_params[:taxi]
    booking.status = 'accepted'
    booking.save
  end

  # 택시기사가 수락한 배차예약에 대해 승객을 이동시켜 완료하였을 때
  def finish_driving
    # 배차요청에 대해서 운송완료한 배차예약 번호를 Parameter로 받는다.
    booking = Booking.find_by(id: params[:id])
    
    # 해당 배차예약의 상태를 finished로 변경한다.
    booking.status = 'finished'
    booking.save
    @msg = {
        message: 'This booking finished driving'
    }
    render json: @msg
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
      params.require(:booking).permit(:destination, :status, :taxi, :created_at, :updated_at, :user_id)
    end

    def driver_params
      params.require(:booking).permit(:taxi, :user_id)
    end
end
