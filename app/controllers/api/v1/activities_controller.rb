class Api::V1::ActivitiesController < Api::V1::ApiController

  before_action :set_group,    except: :index
  before_action :set_activity, except: :index
  before_action :authenticate, except: [:index, :show, :participants]

  before_action :verify_has_activity, only: [:update, :destroy, :participants]
  before_action :verify_group_admin,  only: [:update, :destroy, :create]

  def index
    success(json: Activity.all)
  end

  # POST api/v1/groups/:id/activity
  def create
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
    success(json: @activity.participants, root: :users)
  end

  # GET api/v1/groups/:id/activity/join
  def join
    participation = @activity.participations.build(user: @current_user)

    if participation.save
      success
    else
      failure(status: :bad_request, error: participation.errors.messages)
    end
  end

  # GET api/v1/groups/:id/activity/unjoin
  def unjoin
    participation = @activity.participations.find_by(user_id: @current_user.id)

    if participation.nil?
      failure(status: :bad_request, error: "User is not a participant")
    elsif participation.destroy
      success
    else
      failure(status: :bad_request, error: participation.errors.messages)
    end
  end

  # PATCH/PUT api/v1/groups/:id/activity
  def update
    if @activity.update(activity_params)
      success
    else
      failure(status: :bad_request, error: @activity.errors.messages)
    end
  end

  # DELETE api/v1/groups/:id/activity
  def destroy
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

  def verify_has_activity
    unless @activity
      failure(status: :bad_request, error: "Group hasn't a activity")
    end
  end

  def verify_group_admin
    unless @group.managed_by?(@current_user)
      failure(error: "User isn't authorized to do that.")
    end
  end

end
