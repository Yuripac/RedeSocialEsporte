class Api::V1::ApiController < ActionController::Base

  protect_from_forgery with: :null_session

  before_action :cors_preflight_check
  after_action :cors_set_access_control_headers

  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  def authenticate
    api_key = request.headers['X-Api-Key']
    @user = User.where(api_key: api_key).first if api_key

    failure(error: "x-api-key is wrong") unless @user
  end

  def success(status: :ok, json: {})
    options = { status: status, json: json }

    render options
  end

  def failure(status: :unauthorized, error: {})
    options = { status: status, json: error }

    render options
  end

  def not_found
    failure(status: :not_found)
  end

  def cors_set_access_control_headers
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'POST, GET, PUT, DELETE, OPTIONS'
    headers['Access-Control-Allow-Headers'] = 'Origin, Content-Type, Accept, X-Api-Key, X-Access-Token'
    headers['Access-Control-Max-Age'] = "1728000"
  end

  def cors_preflight_check
    if request.method == 'OPTIONS'
      headers['Access-Control-Allow-Origin'] = '*'
      headers['Access-Control-Allow-Methods'] = 'POST, GET, PUT, DELETE, OPTIONS'
      headers['Access-Control-Allow-Headers'] = 'X-Requested-With, X-Prototype-Version, Token'
      headers['Access-Control-Max-Age'] = '1728000'

      render :text => '', :content_type => 'text/plain'
    end
  end

end
