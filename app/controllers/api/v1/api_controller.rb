class Api::V1::ApiController < ActionController::Base

  protect_from_forgery with: :null_session

  def authenticate
    api_key = params[:api_key]
    @user = User.where(api_key: api_key).first if api_key

    unless @user
      failure(json: {info: "User not exists"})
      return false
    end
  end

  def success(options = {})
    default = { status: :ok, json: { success: true } }
    options = default.deep_merge(options)

    response_base(options)
  end

  def failure(options = {})
    default = { status: :unauthorized, json: { success: false } }
    options = default.deep_merge(options)

    response_base(options)
  end

  private

  def response_base(options)
    default_options = {
      status: '', json: { success: '', data: {}, info: '', error: {} }
    }
    options = default_options.deep_merge(options)

    render options
  end

end