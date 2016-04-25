
class Api::V1::UsersController < Api::V1::ApiController

  before_action :authenticate, only: [:update, :follow, :unfollow,
     :followers, :following]
  before_action :set_user, except: [:followers, :following]

  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  # GET api/v1/users/:id
  def show
    success(json: @user)
  end

  # GET api/v1/users/:id/follow
  def follow
    relationship = @current_user.active_relationships.build(followed: @user)

    if relationship.save
      success
    else
      failure(status: :bad_request, error: relationship.errors.messages)
    end
  end

  def unfollow
    relationship = @current_user.active_relationships.find_by(followed_id: @user.id)

    if relationship.nil?
      failure(status: :bad_request, error: "current user don't follows this user")
    elsif relationship.destroy
      success
    else
      failure(status: :bad_request, error: relationship.errors.messages)
    end
  end

  def followers
    success(json: @current_user.followers)
  end

  def following
    success(json: @current_user.following)
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
