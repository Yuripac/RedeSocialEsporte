class Api::V1::ActivitiesController < Api::V1::ApiController

  before_action :set_group
  before_action :authenticate, except: :show

  include Api::V1::VerifyGroupOwner

  # POST api/v1/groups/:id/activity
  def create
    failure(status: :bad_request, error: "Group already has a activity") and return if @group.activity

    activity = @group.build_activity(activity_params)

    if activity.save
      success(status: :created)
    else
      failure(status: :bad_request, error: activity.errors.messages)
    end
  end

  # GET api/v1/groups/:id/activity
  def show
    success(json: @group.activity)
  end

  # GET api/v1/groups/:id/activity/join
  def join
    participation = @group.activity.participations.build(user: @user)

    if participation.save
      success
    else
      failure(status: :bad_request, error: participation.errors.messages)
    end
  end

  # GET api/v1/groups/:id/activity/unjoin
  def unjoin
    participation = @group.activity.participations.find_by!(user_id: @user.id)

    if participation.destroy
      success
    else
      failure(status: :bad_request, error: participation.errors.messages)
    end
  end

  # PATCH/PUT api/v1/groups/:id/activity
  def update
    failure(status: :bad_request, error: "Group hasn't a activity") and return unless @group.activity

    if @group.activity.update(activity_params)
      success
    else
      failure(status: :bad_request, error: @group.activity.errors.messages)
    end
  end

  # DELETE api/v1/groups/:id/activity
  def destroy
    failure(status: :bad_request, error: "Group hasn't a activity") and return unless @group.activity

    @group.activity.destroy
    success
  end

  private

  def set_group
    @group = Group.find(params["group_id"])
  end

  def activity_params
    params.require(:activity).permit(:latitude, :longitude, :address, :date)
  end

end
