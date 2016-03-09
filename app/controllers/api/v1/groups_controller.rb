class Api::V1::GroupsController < Api::V1::ApiController

  before_action :set_group,         only:   [:join, :show, :members, :unjoin, :update, :destroy]
  before_action :authenticate,      except: [:index, :show, :members]

  include VerifyGroupOwner

  # GET /api/v1/groups
  def index
    groups = Group.includes(:sport, :activity)

    success(json: groups.to_json(include: [:sport, :activity]))
  end

  # POST /api/v1/groups
  def create
    group = @user.groups.build(group_params)

    if group.save
      success(status: :created)
    else
      failure
    end
  end

  # GET /api/v1/groups/1
  def show
    if @group
      success(json: @group.to_json(include: [:sport, :activity]))
    else
      failure(status: :not_found)
    end
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
    unless @group.members.include?(@user)
      @group.members << @user
      success
    else
      failure(status: :bad_request)
    end
  end

  # GET /api/v1/groups/1/unjoin
  def unjoin
    if @group.members.include?(@user) && !@group.owned_by?(@user)
      @group.members.destroy(@user)
      success
    else
      failure(status: :bad_request)
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
    @group = Group.find_by_id(params[:id])
  end

  def group_params
    params.require(:group).permit(:name, :description, :sport_id)
  end

end
