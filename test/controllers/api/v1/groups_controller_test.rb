require "test_helper"

class Api::V1::GroupsControllerTest < ActionController::TestCase

  setup do
    @adm_group = groups(:one)
    @joined_group = groups(:two)
    @not_joined_group = groups(:four)

    @activity = activities(:one)

    # sets a user
    request.headers["X-Api-Key"] = users(:one).api_key
  end

  test "should get index" do
    get :index
    assert_response :success

    assert_not_nil response.body
  end

  test "should get my" do
    get :my

    assert_response :success
    assert_not_nil response.body
  end

  test "should get members" do
    get :members, id: @adm_group

    assert_response :success
    assert_not_nil response.body
  end

  test "should get join" do
    assert_difference("Membership.count") do
      get :join, id: @not_joined_group
    end

    assert_response :success
  end

  test "should fail when the user already joins" do
    assert_no_difference("Membership.count") do
      get :join, id: @joined_group
    end

    assert_response :bad_request
  end

  test "should get unjoin" do
    assert_difference("Membership.count", -1) do
      get :unjoin, id: @joined_group
    end

    assert_response :success
  end

  test "should fail when the user not joins" do
    assert_no_difference("Membership.count") do
      get :unjoin, id: @not_joined_group
    end

    assert_response :bad_request
  end

  test "should create group" do
    assert_difference('Group.count') do
      post :create,
           group: {
             sport_id:    @adm_group.sport_id,
             description: @adm_group.description,
             name:        @adm_group.name
           }
    end

    assert_response :created
  end

  test "should create group and activity" do
    assert_difference(["Group.count", "Activity.count"]) do
      post :create,
           group: {
             sport_id:    @adm_group.sport_id,
             description: @adm_group.description,
             name:        @adm_group.name
           },
           activity: {
             latitude:  @activity.latitude,
             longitude: @activity.longitude,
             address:   @activity.address,
             date:      @activity.date
           }
    end

    assert_response :created
  end

  test "should show group" do
    get :show, id: @adm_group
    assert_response :success

    assert_not_nil response.body
  end

  test "should update group" do
    patch :update, id: @adm_group,
          group: {
            sport_id:    @adm_group.sport_id,
            description: @adm_group.description,
            name:        @adm_group.name
          }
    assert_response :success
  end

  test "should fails when a not admin tries to update a group" do
    patch :update, id: @joined_group,
          group: {
            sport_id:    @joined_group.sport_id,
            description: @joined_group.description,
            name:        @joined_group.name
          }
    assert_response :unauthorized
  end

  test "should destroy group" do
    assert_difference('Group.count', -1) do
      delete :destroy, id: @adm_group
    end

    assert_response :success
  end

  test "should fails when a not admin tries to destroys a group" do
    assert_no_difference("Group.count") do
      delete :destroy, id: @joined_group
    end

    assert_response :unauthorized
  end

end
