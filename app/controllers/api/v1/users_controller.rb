
class Api::V1::UsersController < Api::V1::ApiController

  before_action :authenticate, only: [:update]
  before_action :set_user

  # GET api/v1/users/:id
  def show
    @user ? success(json: @user.to_json(except: "api_key")) : failure(status: :not_found)
  end

  # PATCH/PUT api/v1/users/:id
  def update
    @user.update(user_params) ? success : failure(status: :bad_request)
  end

  private

  def set_user
    @user = User.find_by_id(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :sport_id)
  end

end
