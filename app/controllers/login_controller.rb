class LoginController < ApplicationController

  def new
  end

  def create
    user = User.find_by_email(params[:user][:email])

    if user && user.valid_password?(params[:user][:password])
      session[:user_id] = user.id
      redirect_to root_path
    else
      flash.now[:alert] = "E-mail or password is wrong."
      render :new
    end
  end

end