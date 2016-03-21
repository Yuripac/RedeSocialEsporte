require "test_helper"

class Api::V1::ActivitiesControllerTest < ActionController::TestCase

  setup do
    @activity1 = activities(:one)
    @activity2 = activities(:two)

    @group3 = groups(:three)

    # sets a user
    request.headers['X-Api-Key'] = users(:one).api_key
  end

  test "should get participants" do
    get :participants, group_id: @activity1.group, id: @activity1

    assert_response :success
    assert_not_nil response.body
  end

  test "should get join" do
    assert_difference("Participation.count") do
      get :join, group_id: @activity2.group, id: @activity2
    end

    assert_response :success
  end

  test "should get unjoin" do
    get :join, group_id: @activity2.group, id: @activity2

    assert_difference("Participation.count", -1) do
      get :unjoin, group_id: @activity2.group, id: @activity2
    end

    assert_response :success
  end

  test "should create activity" do
    assert_difference("Activity.count") do
      post :create, group_id: @group3, activity: {
                                                   latitude: @activity2.latitude,
                                                   longitude: @activity2.longitude,
                                                   address: @activity2.address,
                                                   date: @activity2.date
                                                 }
    end

    assert_response :created
  end

  test "should show activity" do
    get :show, group_id: @activity1.group, id: @activity1
    assert_response :success

    assert_not_nil response.body
  end

  test "should update activity" do
    patch :update, group_id: @activity1.group, id: @activity1, activity: {
                                                                           latitude: @activity1.latitude,
                                                                           longitude: @activity1.longitude,
                                                                           address: @activity1.address,
                                                                           date: @activity1.date
                                                                         }
    assert_response :success
  end

  test "should destroy activity" do
    skip
    assert_difference('Activity.count', -1) do
      delete :destroy, group_id: @activity1.group, id: @activity1
    end

    assert_response :success
  end
end
