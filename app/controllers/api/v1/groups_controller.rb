
class Api::V1::GroupsController < Api::V1::ApiController

  before_action :set_group, only: [:join, :show, :members, :admins, :unjoin, :update, :destroy]
  before_action :authenticate, except: [:index, :show, :members, :admins]
  before_action :verify_group_admin, only: [:update, :destroy]

  # GET /api/v1/groups
  def index
    success(json: Group.all)
  end

  # POST /api/v1/groups
  def create
    group = Group.new(group_params)
    group.admins << @user

    group.build_activity(activity_params)

    if group.save
      success(status: :created)
    else
      failure(status: :bad_request, error: group.errors.messages)
    end
  end

  # GET /api/v1/groups/1
  def show
    # byebug
    success(json: @group)
  end

  # GET /api/v1/groups/my
  def my
    groups = @user.membership_groups.includes(:sport, :activity)
    success
  end

  # GET /api/v1/groups/:id/members
  def members
    success(json: @group.members, root: :users)
  end

  def admins
    success(json: @group.admins, root: :admins)
  end

  # GET /api/v1/groups/1/join
  def join
    membership = @group.memberships.build(user: @user)

    if membership.save
      success
    else
      failure(status: :bad_request, error: membership.errors.messages)
    end
  end

  # GET /api/v1/groups/1/unjoin
  def unjoin
    membership = @group.memberships.find_by(user_id: @user.id)

    if membership.nil?
      failure(status: :bad_request, error: "User is not a member")
    elsif membership.destroy
      success
    else
      failure(status: :bad_request, error: membership.errors.messages)
    end
  end

  # PATCH/PUT /api/v1/groups/1
  def update
    if @group.update(group_params)
      success
    else
      failure(status: :bad_request, error: @group.errors.messages)
    end
  end

  # DELETE /api/v1/groups/1
  def destroy
    @group.destroy
    success
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_group
    @group = Group.find(params[:id])
  end

  def group_params
    params.require(:group).permit(:name, :description, :sport_id)
  end

  def activity_params
    params.fetch(:activity, {}).permit(:latitude, :longitude, :address, :date)
  end

  def verify_group_admin
    unless @group.managed_by?(@user)
      failure(error: "User isn't authorized to do that.")
    end
  end

end
