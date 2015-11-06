class LoginController < ApplicationController

  def create
    auth = request.env['omniauth.auth']

    user = User.find_or_create_with_omniauth(auth)

    session[:user_id] = user.id

    redirect_to root_path, notice: 'You are logged'
  end

  def failure
    redirect_to root_path
  end


  def destroy
    session.clear
    redirect_to root_path, notice: 'Bye bye'
  end

end