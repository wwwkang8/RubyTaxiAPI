class SessionsController < ApplicationController
  def new

  end

  def create
    @user =User.find_by(email: params[:session][:email].downcase)

    if(@user && (@user.pwd==params[:session][:pwd]))
      session[:user_id]=@user.id
      error_message_response('You have successfully logged in', @user)
    else
      error_message_response('Login fail. Please check the email or password', nil)
    end

  end


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

  def create_token
    user = User.find_by(email: params[:email])

    if user.present?&&check_valid_password(user, params[:pwd])
      render json: user.as_json(only: [:id, :email, :authentication_token]), status: :created
    else
      error_message_response('No user found. Please check email/password', nil)
    end

  end

  def destroy_token
    current_user.authentication_token = nil
    if current_user.save
      head(:ok)
    else
      head(:unauthorized)
    end
  end

  def create_token2
    user = User.where(email: params[:email]).first

    if user.valid_password?(params[:pwd])
      render json: user.as_json(only: [:id, :email]), status: :created
    else
      head(:unauthorized)
    end
  end

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