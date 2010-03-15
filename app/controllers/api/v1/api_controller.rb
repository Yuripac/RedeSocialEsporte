class Api::V1::ApiController < ActionController::Base

  protect_from_forgery with: :null_session

  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  def authenticate
    api_key = request.headers['X-Api-Key']
    @user = User.where(api_key: api_key).first if api_key

    failure(error: "x-api-key is wrong") unless @user
  end

  def success(opts = {})
    options = { status: :ok, json: {} }
    render options.deep_merge(opts)
  end

  def failure(opts = {})
    options = { status: :unauthorized, json: {} }
    render options.deep_merge(opts)
  end

  def not_found
    failure(status: :not_found)
  end

end
