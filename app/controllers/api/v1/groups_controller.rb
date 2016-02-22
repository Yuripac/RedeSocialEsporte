class Api::V1::GroupsController < Api::V1::ApiController

  before_action :set_group, only: [:join, :show, :unjoin, :update, :destroy]
  before_action :authenticate, except: [:index, :show]

  # GET /groups
  def index
    groups = Group.all
    groups_attributes = groups.map { |group| group.attributes }

    success(json: groups_attributes)
  end

  # POST /groups
  def create
    group = @user.created_groups.build(group_params) # SECURE
    #group = @user.created_groups.build(params) # UNSECURE

    group.save ? success(status: :created) : failure
  end

  # GET /groups/1
  def show
    @group ? success(json: @group.attributes) : failure(status: :not_found)
  end

  # GET /groups/my
  def my
    groups = @user.groups
    groups_attributes = groups.map { |group| group.attributes }

    success(json: groups_attributes)
  end

  # GET /groups/1/join
  def join
    member = Member.new(user: @user, group: @group)

    begin
      member.save ? success : failure
    rescue ActiveRecord::RecordNotUnique
      failure(status: :bad_request)
    end
  end

  # GET /groups/1/unjoin
  def unjoin
    member = Member.find_by(user: @user, group: @group)

    if member && !@user.owner?(@group)
      member.destroy
      success
    else
      failure(status: :bad_request)
    end
  end

  # PATCH/PUT /groups/1
  def update
    if @user.owner?(@group)
      @group.update(group_params) ? success : failure(status: :bad_request)
    else
      failure
    end
  end

  # DELETE /groups/1
  def destroy
    if @user.owner?(@group)
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

    unless @group
      failure(status: :not_found)
      return false
    end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def group_params
    # params.permit(:name, :description, :sport)
    params.require(:group).permit(:name, :description, :sport)
  end

end
