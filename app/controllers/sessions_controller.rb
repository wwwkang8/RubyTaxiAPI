class SessionsController < ApplicationController
  def new

  end

  def create
    @user =User.find_by(email: params[:session][:email].downcase)
    if(@user && (@user.pwd==params[:session][:pwd]))
      session[:user_id]=@user.id
      @msg = {
          message: "You have successfully logged in",
          user: User.find_by(id: session[:user_id])
      }
      render json: @msg
    else
      @msg = {
          message: "Login fail. Please check the email or password.",
          user: User.find_by(id: session[:user_id])
      }
      render json: @msg
    end
  end

  def destroy
    # session[:user_id] = nil
    @user = User.find_by_id(params[:session][:id])
    session.delete(@user.id)
    @msg = {
        message: "Session deleted",
        user: User.find_by_id(session[:user_id])
    }
    render json: @msg
  end

end