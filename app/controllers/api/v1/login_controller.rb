require 'json'

class Api::V1::LoginController < Api::V1::ApiController

  before_action :set_user

  respond_to :json

  # POST  /api/v1/login
  def create
    if @user.save
      response.headers['X-Api-Key'] = @user.api_key
      success
    else
      failure(status: :bad_request)
    end
  end

  private

  def set_user
    begin
      id = graph['id']
      @user = User.find_or_create_with_api(id, params)
    rescue Koala::Facebook::APIError => e
      failure(status: :bad_request)
    end
  end

  # request user's graph from facebook
  def graph
    access_token = params[:access_token]
    User.koala(access_token)
  end

  def exception_facebook
    failure(status: :bad_request)
  end

end
