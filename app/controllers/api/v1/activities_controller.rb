class Api::V1::ActivitiesController < Api::V1::ApiController

  before_action :set_group
  before_action :authenticate, except: :show

  # POST api/v1/groups/:id/activity
  def create
    unless @group.activity
      if @group.owned_by?(@user)
        @activity = @group.build_activity(activity_params)

        if @activity.save
          success(status: :created)
        else
          failure(error: @activity.errors.messages)
        end
      else
        failure
      end
    else
      failure(status: :bad_request, error: "Group already has a activity")
    end
  end

  # GET api/v1/groups/:id/activity
  def show
    success(json: @group.activity)
  end

  # PATCH/PUT api/v1/groups/:id/activity
  def update
    if @group.activity
      if @group.owned_by?(@user)
        @group.activity.update(activity_params)
        success
      else
        failure
      end
    else
      failure(status: :bad_request, error: "Group hasn't a activity")
    end
  end

  # DELETE api/v1/groups/:id/activity
  def destroy
    if @group.activity
      if @group.owned_by?(@user)
        @group.activity.destroy
        success
      else
        failure
      end
    else
      failure(status: :bad_request, error: "Group hasn't a activity")
    end
  end

  private

  def set_group
    @group = Group.find_by_id(params["group_id"])
  end

  def activity_params
    params.require(:activity).permit(:latitude, :longitude, :address)
  end

end
