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

  def success(options = {})
    default = { status: :ok, json: {} }
    options = default.merge(options)

    render options
  end

  def failure(options = {})
    default = { status: :unauthorized }
    options = default.merge(options)

    render options
  end

end
