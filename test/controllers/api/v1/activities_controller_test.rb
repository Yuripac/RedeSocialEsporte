require "test_helper"

class Api::V1::ActivitiesControllerTest < ActionController::TestCase

  setup do
    @adm_activity = activities(:one)
    @joined_activity = activities(:two)
    @not_joined_activity = activities(:three)
    @not_joined_group_and_activity = activities(:six)

    @no_activity_adm_group = groups(:five)

    # sets a user
    request.headers['X-Api-Key'] = users(:one).api_key
  end

  test "should get participants" do
    get :participants, group_id: @adm_activity.group, id: @adm_activity
    assert_response :success
    assert_not_nil response.body
  end

  test "should get join" do
    assert_difference("Participation.count") do
      get :join, group_id: @not_joined_activity.group, id: @not_joined_activity
    end
    assert_response :success
  end

  test "should fail when the user already joins" do
    get :join, group_id: @joined_activity.group, id: @joined_activity
    assert_response :bad_request
  end

  test "should fail when the user not joins the activity's group" do
    get :join, group_id: @not_joined_group_and_activity.group,
        id: @not_joined_group_and_activity
    assert_response :bad_request
  end

  test "should get unjoin" do
    assert_difference("Participation.count", -1) do
      get :unjoin, group_id: @joined_activity.group, id: @joined_activity
    end
    assert_response :success
  end

  test "should fail when the user not joins" do
    get :unjoin, group_id: @not_joined_activity.group, id: @not_joined_activity
    assert_response :bad_request
  end


  test "should create activity" do
    assert_difference("Activity.count") do
      post :create,
           group_id: @no_activity_adm_group,
           activity: {
                       latitude: @not_joined_activity.latitude,
                       longitude: @not_joined_activity.longitude,
                       address: @not_joined_activity.address,
                       date: @not_joined_activity.date
                     }
    end
    assert_response :created
  end

  test "should show activity" do
    get :show, group_id: @adm_activity.group, id: @adm_activity
    assert_response :success
    assert_not_nil response.body
  end

  test "should update activity" do
    patch :update,
          group_id: @adm_activity.group,
          id:  @adm_activity,
          activity: {
                      latitude: @adm_activity.latitude,
                      longitude: @adm_activity.longitude,
                      address: @adm_activity.address,
                      date: @adm_activity.date
                    }
    assert_response :success
  end

  test "should fails when a not admin tries to update a activity" do
    patch :update,
          group_id: @joined_activity.group,
          id:  @joined_activity,
          activity: {
                      latitude: @joined_activity.latitude,
                      longitude: @joined_activity.longitude,
                      address: @joined_activity.address,
                      date: @joined_activity.date
                    }
    assert_response :unauthorized
  end

  test "should destroy activity" do
    assert_difference('Activity.count', -1) do
      delete :destroy, group_id: @adm_activity.group, id: @adm_activity
    end
    assert_response :success
  end

  test "should fails when a not admin tries to destroys a activity" do
    delete :destroy, group_id: @joined_activity.group, id: @joined_activity
    assert_response :unauthorized
  end

end
