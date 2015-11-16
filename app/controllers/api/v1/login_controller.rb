class Api::V1::LoginController < Api::V1::ApiController

  respond_to :json

  # POST  /api/v1/login
  # Must checks the access_token authenticity and log in a user
  def create
    access_token = params[:access_token]
    data = User.koala(access_token)

    # If access token is expired must return error.
    if data[:error].nil?
      user = User.find_or_create_with_api(data['id'], params)

      if user.save
        success(json: { info: 'Logged in', data: {api_key: user.api_key}})
      else
        failure(json: { error: user.errors.messages })
      end
    else
      failure(json: { error: data[:error] })
    end

  end

end