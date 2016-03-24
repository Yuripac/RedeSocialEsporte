class Api::V1::ActivitiesController < Api::V1::ApiController

  before_action :set_group
  before_action :set_activity
  before_action :authenticate, except: [:show, :participants]

  include Api::V1::VerifyGroupAdmin

  # POST api/v1/groups/:id/activity
  def create
    failure(status: :bad_request, error: "Group already has a activity") and return if @activity
    activity = @group.build_activity(activity_params)

    if activity.save
      success(status: :created)
    else
      failure(status: :bad_request, error: activity.errors.messages)
    end
  end

  # GET api/v1/groups/:id/activity
  def show
    success(json: @activity)
  end

  # GET api/v1/groups/:id/activity/participants
  def participants
    failure(status: :bad_request, error: "Group hasn't a activity") and return unless @activity

    success(json: @activity.participants.to_json(except: "api_key", include: :sport))
  end

  # GET api/v1/groups/:id/activity/join
  def join
    participation = @activity.participations.build(user: @user)

    if participation.save
      success
    else
      failure(status: :bad_request, error: participation.errors.messages)
    end
  end

  # GET api/v1/groups/:id/activity/unjoin
  def unjoin
    participation = @activity.participations.find_by!(user_id: @user.id)

    if participation.destroy
      success
    else
      failure(status: :bad_request, error: participation.errors.messages)
    end
  end

  # PATCH/PUT api/v1/groups/:id/activity
  def update
    failure(status: :bad_request, error: "Group hasn't a activity") and return unless @activity

    if @activity.update(activity_params)
      success
    else
      failure(status: :bad_request, error: @activity.errors.messages)
    end
  end

  # DELETE api/v1/groups/:id/activity
  def destroy
    failure(status: :bad_request, error: "Group hasn't a activity") and return unless @activity

    @activity.destroy
    success
  end

  private

  def set_group
    @group = Group.find(params["group_id"])
  end

  def set_activity
    @activity = @group.activity
  end

  def activity_params
    params.require(:activity).permit(:latitude, :longitude, :address, :date)
  end

end
