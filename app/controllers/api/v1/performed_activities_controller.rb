class Api::V1::PerformedActivitiesController < Api::V1::ApiController

  before_action :set_group

  def index
    success(json: @group.performed_activities)
  end

  private

  def set_group
    @group = Group.find(params[:group_id])
  end

end
