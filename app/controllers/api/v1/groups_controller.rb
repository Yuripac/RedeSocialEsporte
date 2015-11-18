class Api::V1::GroupsController < Api::V1::ApiController

  before_action :set_group, only: [:join, :show]
  before_action :authenticate, except: [:index, :show]

  # GET /groups
  def index
    groups = Group.all
    groups_attributes = groups.map {|group| group.attributes}
    success(json: {data: groups_attributes})
  end

  # GET /groups/1
  def show
    if @group
      success(json: {data: @group.attributes})
    else
      failure(json: {info: 'Group not exists'})
    end
  end

  # GET /groups/my
  def my
    # Must be @user.groups
    groups = @user.groups
    groups_attributes = groups.map {|group| group.attributes}
    success(json: {data: groups_attributes})
  end

  # GET /groups/1/join
  def join
  end

  # GET /groups/1/unjoin
  def unjoin
  end

  # POST /groups
  def create
  end

  # PATCH/PUT /groups/1
  def update
  end

  # DELETE /groups/1
  def destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_group
    @group = Group.find_by_id(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def group_params
    params.require(:group).permit(:name, :description, :sport)
  end

end