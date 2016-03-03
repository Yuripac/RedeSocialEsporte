
class LoginController < ApplicationController

  def create
    auth = request.env['omniauth.auth']
    user = User.find_or_initialize_with_omniauth(auth)

    if User.exists?(user)
      session[:user_id] = user.id
      redirect_to root_path, notice: "You are logged in"
    elsif user.save
      session[:user_id] = user.id
      redirect_to edit_user_path(user), notice: 'You are logged in'
    else
      redirect_to root_path, alert: 'You have blank fields'
    end
  end

  def destroy
    session.clear
    redirect_to root_path, notice: 'Bye bye'
  end

end
