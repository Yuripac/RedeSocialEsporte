
class GroupsController < ApplicationController
  before_action :authorize_user, except: [:show, :index]
  before_action :set_group, only: [:join, :unjoin, :show]

  # GET /groups
  # GET /groups.json
  def index
    @groups = Group.includes(:members, :owner, :sport)
  end

  # GET /groups/my
  def my
    @groups = current_user.membership_groups.includes(:members, :owner, :sport)
  end

  # GET /groups/1/join
  def join
    unless @group.members.include?(current_user)
      @group.members << current_user
      flash[:notice] = "You joined a group"
    else
      flash[:alert] = "You can't join"
    end
    redirect_to groups_path
  end

  # GET /groups/1/unjoin
  def unjoin
    if @group.members.include?(current_user) && !@group.owned_by?(current_user)
      @group.members.destroy(current_user)
      flash[:notice] = "You left a group"
    else
      flash[:alert] = "You can't leave this group"
    end
    redirect_to groups_path
  end

  # GET /groups/1
  # GET /groups/1.json
  def show
  end

  # GET /groups/new
  def new
    @group = current_user.groups.build
  end

  # GET /groups/1/edit
  def edit
    @group = current_user.groups.find(params[:id])
  end

  # POST /groups
  def create
    @group  = current_user.groups.build(group_params)

    if @group.save
      redirect_to @group, notice: 'Group was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /groups/1
  def update
    @group = current_user.membership_groups.find(params[:id])

    if @group.update(group_params)
      redirect_to @group, notice: 'Group was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /groups/1
  def destroy
    @group = current_user.membership_groups.find(params[:id])
    @group.destroy

    redirect_to groups_url, notice: 'Group was successfully destroyed.'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_group
    @group = Group.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def group_params
    params.require(:group).permit(:name, :description, :sport_id)
  end
end
