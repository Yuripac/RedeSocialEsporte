class GroupsController < ApplicationController
  before_action :authorize_user, only: [:new, :create, :edit, :update, :destroy]
  before_action :set_group, only: [:join, :show]

  # GET /groups
  # GET /groups.json
  def index
    @groups = Group.all
  end

  # Get /groups/my
  def my
    @groups = current_user.groups
  end

  # GET /groups/1/join
  def join
    @member = Member.new(user: current_user, group: @group, owner: false)

    if @member.save
      flash[:notice] = "Joined"
    else
      flash[:alert] = "You can't join"
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
  # POST /groups.json
  def create
    @group  = Group.new(group_params)
    @member = Member.new(user: current_user, group: @group, owner: true)

    respond_to do |format|
      if @group.save
        @member.save
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
    if current_user == nil
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
