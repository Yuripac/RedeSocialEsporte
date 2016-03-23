require "test_helper"

class Api::V1::PerformedActivitiesControllerTest < ActionController::TestCase

  setup do
    @group = groups(:one)
  end

  test "should get index" do
    get :index, group_id: @group, id: @group.performed_activities

    assert_response :success
    assert_not_nil response.body
  end

end
