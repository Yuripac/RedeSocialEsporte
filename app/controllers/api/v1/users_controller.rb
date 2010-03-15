
class Api::V1::UsersController < Api::V1::ApiController

  before_action :authenticate, only: [:update]
  before_action :set_user

  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  # GET api/v1/users/:id
  def show
    success(json: @user)
  end

  # PATCH/PUT api/v1/users/:id
  def update
    @user.update(user_params) ? success : failure(status: :bad_request)
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :sport_id)
  end

end
