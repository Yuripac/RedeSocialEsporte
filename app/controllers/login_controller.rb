class LoginController < ApplicationController
  before_action :not_authorize_user, only: [:new, :create]

  def new
  end

  def logout
    session.clear
    redirect_to root_path, notice: "disconnected"
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

  def not_authorize_user
    unless current_user.nil?
      redirect_to root_path, alert: "You are already logged."
    end
  end

end