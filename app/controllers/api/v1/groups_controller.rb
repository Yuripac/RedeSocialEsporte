
class Api::V1::GroupsController < Api::V1::ApiController

  before_action :set_group,         only:   [:join, :show, :members, :unjoin, :update, :destroy]
  before_action :authenticate,      except: [:index, :show, :members]

  include Api::V1::VerifyGroupOwner

  # GET /api/v1/groups
  def index
    groups = Group.includes(:sport, :activity)

    success(json: groups.to_json(include: [:sport, :activity]))
  end

  # POST /api/v1/groups
  def create
    group    = @user.groups.build(group_params)
    activity = group.build_activity(activity_params)

    if group.save
      activity.save
      success(status: :created)
    else
      failure(status: :bad_request, error: group.errors.messages)
    end
  end

  # GET /api/v1/groups/1
  def show
    success(json: @group.to_json(include: [:sport, :activity]))
  end

  # GET /api/v1/groups/my
  def my
    groups = @user.membership_groups.includes(:sport, :activity)

    success(json: groups.to_json(include: [:sport, :activity]))
  end

  def members
    success(json: @group.members.to_json(except: "api_key", include: :sport))
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
    membership = @group.memberships.find_by!(user_id: @user.id)

    if membership.destroy
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

end
