
class GroupsController < ApplicationController
  before_action :authorize_user, except: [:show, :index]
  before_action :set_group, only: [:join, :unjoin, :show]

  # GET /groups
  # GET /groups.json
  def index
    @groups = Group.includes(:users, :user, :sport)
  end

  # GET /groups/my
  def my
    @groups = current_user.groups.includes(:users, :user, :sport)
  end

  # GET /groups/1/join
  def join
    @member = Membership.new(user: current_user, group: @group)

    if @member.save
      flash[:notice] = "You joined a group"
    else
      flash[:alert] = "You can't join"
    end

    redirect_to groups_path
  end

  # GET /groups/1/unjoin
  def unjoin
    @member = Membership.find_by(user: current_user, group: @group)

    if @member && !@group.owner?(current_user)
      @member.destroy
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
    @group = current_user.created_groups.build
  end

  # GET /groups/1/edit
  def edit
    @group = current_user.created_groups.find(params[:id])
  end

  # POST /groups
  def create
    @group  = current_user.created_groups.build(group_params)

    if @group.save
      @group.users << current_user
      redirect_to @group, notice: 'Group was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /groups/1
  def update
    @group = current_user.groups.find(params[:id])

    if @group.update(group_params)
      redirect_to @group, notice: 'Group was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /groups/1
  def destroy
    @group = current_user.groups.find(params[:id])
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
