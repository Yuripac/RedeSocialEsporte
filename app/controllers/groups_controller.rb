class GroupsController < ApplicationController
  before_action :authorize_user, except: [:show, :index]
  before_action :set_group, only: [:join, :unjoin, :show]

  # GET /groups
  # GET /groups.json
  def index
    @groups = Group.includes(:users, :user).all
  end

  # GET /groups/my
  def my
    @groups = current_user.groups.includes(:users, :user)
  end

  # GET /groups/1/join
  def join
    @member = Member.new(user: current_user, group: @group)

    if @member.save
      flash[:notice] = "You joined a group"
    else
      flash[:alert] = "You can't join"
    end

    redirect_to groups_path
  end

  # GET /groups/1/unjoin
  def unjoin
    @member = Member.find_by(user: current_user, group: @group)

    if @member && !current_user.created_groups.include?(@group)
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
  # POST /groups.json
  def create
    @group  = current_user.created_groups.build(group_params)

    respond_to do |format|
      if @group.save
        format.html { redirect_to @group, notice: 'Group was successfully created.' }
        format.json { render :show, status: :created, location: @group }
      else
        format.html { render :new }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /groups/1
  # PATCH/PUT /groups/1.json
  def update
    @group = current_user.groups.find(params[:id])
    respond_to do |format|
      if @group.update(group_params)
        format.html { redirect_to @group, notice: 'Group was successfully updated.' }
        format.json { render :show, status: :ok, location: @group }
      else
        format.html { render :edit }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /groups/1
  # DELETE /groups/1.json
  def destroy
    @group = current_user.groups.find(params[:id])
    @group.destroy

    respond_to do |format|
      format.html { redirect_to groups_url, notice: 'Group was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def authorize_user
    if current_user.nil?
      redirect_to root_path, alert: 'You need to be Logged to do that.'
    end
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_group
    @group = Group.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def group_params
    params.require(:group).permit(:name, :description, :sport)
  end
end
