class SessionsController < ApplicationController
  def new

  end
  
  # 세션을 이용한 로그인
  def create
    @user =User.find_by(email: params[:session][:email].downcase)

    if(@user && (@user.pwd==params[:session][:pwd]))
      session[:user_id]=@user.id
      error_message_response('You have successfully logged in', @user)
    else
      error_message_response('Login fail. Please check the email or password', nil)
    end

  end

  # 세션 삭제
  def destroy
    session[:user_id] = nil
    # @user = User.find_by_id(params[:session][:id])
    # session.delete(@user.id)
    @msg = {
        message: "Session deleted",
        user: User.find_by_id(session[:user_id])
    }
    render json: @msg
  end
  
  # JWT를 이용해서 로그인
  def create_token
    @user = User.find_by(email: params[:email])


    if @user.present?&&check_valid_password(@user, params[:pwd])
      # JWT 토큰 생성 : User 아이디, 토큰 만료기간을 이용하여 JWT 토큰을 생성하고, 암호화 방식은 HS256 사용
      jwt = JWT.encode({user_id: @user.id, exp: (Time.now + 2.weeks).to_i}, Rails.application.credentials.secret_key_base, 'HS256')

      render :'sessions/create', locals: {token: jwt}, status: :created
      # jwt = JWT.encode({user_id: @user.id, exp: (Time.now + 2.weeks).to_i}, Rails.application.secrets.secret_key_base, 'HS256')
      # render json: @user.as_json(only: [:id, :email, :authentication_token]), locals: {token: jwt}, status: :created
    else
      error_message_response('No user found. Please check email/password', nil)
    end

  end
  
  # JWT 토큰 무효화
  def destroy_token
    current_user.authentication_token = nil
    if current_user.save
      head(:ok)
    else
      head(:unauthorized)
    end
  end
  
  # 입력한 비밀번호가 User 객체의 비밀번호와 맞는지 체크하는 함수
  def check_valid_password(user, pwd)
    user.pwd == pwd
  end

  def error_message_response(message, user, errors = nil)
    render(json:{
        message: message,
        user: user,
        errors: errors
    })
  end

end