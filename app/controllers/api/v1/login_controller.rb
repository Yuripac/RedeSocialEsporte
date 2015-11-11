class Api::V1::LoginController < Api::V1::ApiController

  respond_to :json

  # POST  /api/v1/login
  # Must call the facebook authentication
  def create
    user_id = id_by_token(params[:access_token])

    @user = User.find_or_create_with_api(user_id, params)

    return failure if !@user.save

    render status: :ok, json: { success: true,
                                info: "Logged in",
                                data: @user,
                                error: {}
                              }
  end

  def destroy
    #current_user.update_column(:access_token, nil)
    render status: :ok, json: { success: false,
                                info: "Logged out",
                                data: {},
                                error: {}
                              }
  end

  def failure
    render status: :unauthorized, json: { success: false,
                                          info: 'Login Failed',
                                          data: {},
                                          error: @user.errors.messages
                                        }
  end

end