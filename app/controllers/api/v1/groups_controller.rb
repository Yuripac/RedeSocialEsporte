class Api::V1::GroupsController < Api::V1::ApiController

  before_action :set_group, only: [:join, :show, :members, :unjoin, :update, :destroy]
  before_action :authenticate, except: [:index, :show, :members]

  # GET /api/v1/groups
  def index
    groups = Group.all
    groups_attributes = groups.map { |group| group.attributes }

    success(json: groups_attributes)
  end

  # POST /api/v1/groups
  def create
    group = @user.created_groups.build(group_params)

    group.save ? success(status: :created) : failure
  end

  # GET /api/v1/groups/1
  def show
    @group ? success(json: @group) : failure(status: :not_found)
  end

  # GET /api/v1/groups/my
  def my
    success(json: @user.groups)
  end

  def members
    success(json: @group.users)
  end

  # GET /api/v1/groups/1/join
  def join
    member = Member.new(user: @user, group: @group)

    begin
      member.save ? success : failure
    rescue ActiveRecord::RecordNotUnique
      failure(status: :bad_request)
    end
  end

  # GET /api/v1/groups/1/unjoin
  def unjoin
    member = Member.find_by(user: @user, group: @group)

    if member && !@group.owner?(@user)
      member.destroy
      success
    else
      failure(status: :bad_request)
    end
  end

  # PATCH/PUT /api/v1/groups/1
  def update
    if @group.owner?(@user)
      @group.update(group_params) ? success : failure(status: :bad_request)
    else
      failure
    end
  end

  # DELETE /api/v1/groups/1
  def destroy
    if @group.owner?(@user)
      @group.destroy
      success
    else
      failure
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_group
    @group = Group.find_by_id(params[:id])

    failure(status: :not_found) unless @group
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def group_params
    params.require(:group).permit(:name, :description, :sport)
  end

end
