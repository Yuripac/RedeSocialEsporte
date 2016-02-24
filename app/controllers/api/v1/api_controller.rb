class Api::V1::ApiController < ActionController::Base

  protect_from_forgery with: :null_session

  def authenticate
    api_key = request.headers['X-Api-Key']
    @user = User.where(api_key: api_key).first if api_key

    unless @user
      failure
      return false
    end
  end

  def success(status: :ok, json: {})
    options = {status: status, json: json}

    render options
  end

  def failure(status: :unauthorized, error: {})
    options = {status: status, json: error}

    render options
  end

end
