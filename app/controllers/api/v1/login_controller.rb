class Api::V1::LoginController < Api::V1::ApiController

  respond_to :json

  # POST  /api/v1/login
  # Must checks the access_token authenticity and
  # creates or just returns user if already was created.
  def create
    #user_id = id_by_token(params[:access_token])
    user_id = id_by_token

    @user = User.find_or_create_with_api(user_id, params)

    return failure(@user.errors.messages) if !@user.save

    render status: :ok, json: { success: true,
                                info: "Logged in",
                                data: @user,
                                error: {}
                              }
  end

  # DELETE /api/v1/logout
  # Must delete user's access_token if user is logged in.
  def destroy
    return failure('User is not logged in') if !is_logged_in?

    # Must delete the token to finish 'session'
    @user.update_column(:access_token, nil)

    render status: :ok, json: { success: true,
                                info: "Logged out",
                                data: {},
                                error: {}
                              }
  end

end