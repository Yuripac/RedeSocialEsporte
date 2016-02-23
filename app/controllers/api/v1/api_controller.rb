class Api::V1::ApiController < ActionController::Base

  protect_from_forgery with: :null_session

  def authenticate
    # api_key = request.headers['X-Api-Key']
    api_key = params['x-api-key']
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

  def failure(status: :unauthorized)
    options = {status: status, nothing: true}

    render options
  end

end
