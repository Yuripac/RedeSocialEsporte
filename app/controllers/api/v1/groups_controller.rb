
class Api::V1::GroupsController < Api::V1::ApiController

  before_action :set_group, only: [:join, :show, :members, :admins, :unjoin, :update, :destroy]
  before_action :authenticate, except: [:index, :show, :members, :admins]
  before_action :verify_group_admin, only: [:update, :destroy]

  def index
    success(json: Group.all)
  end

  def create
    group = Group.new group_params
    group.sport_id = sport_params[:id]

    group.admins << @current_user

    group.build_activity(activity_params)

    if group.save
      success(status: :created)
    else
      failure(status: :bad_request, error: group.errors.messages)
    end
  end

  def show
    success(json: @group)
  end

  def my
    groups = @current_user.membership_groups.includes(:sport, :activity)
    success(json: groups)
  end

  def members
    success(json: @group.members, root: :users)
  end

  def admins
    success(json: @group.admins, root: :admins)
  end

  def join
    membership = @group.memberships.build(user: @current_user)

    if membership.save
      success
    else
      failure(status: :bad_request, error: membership.errors.messages)
    end
  end

  def unjoin
    membership = @group.memberships.find_by(user_id: @current_user.id)

    if membership.nil?
      failure(status: :bad_request, error: "user is not a member")
    elsif membership.destroy
      success
    else
      failure(status: :bad_request, error: membership.errors.messages)
    end
  end

  def update
    if @group.update(group_params)
      success
    else
      failure(status: :bad_request, error: @group.errors.messages)
    end
  end

  def destroy
    @group.destroy
    success
  end

  private

  def set_group
    @group = Group.find(params[:id])
  end

  def group_params
    params.require(:group).permit(:name, :description, :activity)
  end

  def sport_params
    params.require(:sport).permit(:id, :name)
  end

  def activity_params
    params.fetch(:activity, {}).permit(:latitude, :longitude, :address, :date)
  end

  def verify_group_admin
    unless @group.managed_by?(@current_user)
      failure(error: "User isn't authorized to do that.")
    end
  end

end
