class UsersController < ApplicationController
  before_action :set_user, only: [:show, :update, :destroy]
  #before_action :authenticate_user

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)
    
    # 잘못입력된 usertype에 대해 에러메시지 리턴          개선 코드 : [passenger, driver].include? @user.usertype, 루비는 not에 대한 메서드도 있다. ex) 물음표 메서드
    return error_message_response('Please choose either passenger or driver in usertype') if %w['passenger', 'driver'].include? @user.usertype

    # 잘못 입력된 비밀번호에 대해서 에러메시지 리턴
    return error_message_response('Password is empty') if @user.pwd.nil?

    # 6자리 미만으로 입력된 비밀번호에 대해서 에러메시지 리턴
    return error_message_response('Please write password at least 6 characters') if @user.pwd.length < 6
    # User가 제대로 생성되었을 때의 성공 메시지
    if @user.save
      @msg = {
          message: 'Account successfully registered'
      }
      render json: @msg, status: :created
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    if @user.update(user_params)
      render :show, status: :ok, location: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json

  # destroy가 잘 되었다는 것을 어떻게 판단해야할까?
  def destroy
    if @user.destroy
      error_message_response('User successfully destroy')
    else
      error_message_response('User failed destroy. Please try again')
    end
  end



  private
    def set_user
      @user = self.current_user
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:email, :pwd, :usertype)
    end
end
