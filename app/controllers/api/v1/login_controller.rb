
class Api::V1::LoginController < Api::V1::ApiController

  before_action :verify_token, :set_user

  respond_to :json

  # POST  /api/v1/login
  def create
    if @user.save
      response.headers['X-Api-Key'] = @user.api_key
      success(json: @user.to_json(only: ["id", "name", "email", "uid", "provider"]))
    else
      failure(status: :bad_request, error: @user.errors.messages)
    end
  end

  private

  def set_user
    @user = User.find_or_create_with_api(graph)
  end

  def verify_token
    app_token    = Rails.application.secrets.facebook["app_token"]
    app_id       = Rails.application.secrets.facebook["app_id"]
    access_token = login_params[:access_token]

    begin
      info = Koala::Facebook::API.new(app_token).debug_token(access_token)
      unless info["data"]["is_valid"]
        failure(status: :bad_request, error: info["data"]["error"]["message"])
      end
    rescue Koala::Facebook::ClientError => e
      failure(status: :bad_request, error: e.fb_error_message)
    end
  end

  # request user's graph from facebook
  def graph
    @graph ||= User.facebook(login_params[:access_token])
  end

  def login_params
    params.require(:login).permit(:access_token)
  end

end
