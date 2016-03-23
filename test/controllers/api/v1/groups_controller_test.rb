require "test_helper"

class Api::V1::GroupsControllerTest < ActionController::TestCase

  setup do
    @group1 = groups(:one)
    @group4 = groups(:four)

    @activity = activities(:one)
    # sets a user
    request.headers['X-Api-Key'] = users(:one).api_key
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
    get :members, id: @group1

    assert_response :success
    assert_not_nil response.body
  end

  test "should get join" do
    assert_difference("Membership.count") do
      get :join, id: @group4
    end

    assert_response :success
  end

  test "should get unjoin" do
    get :join, id: @group4

    assert_difference("Membership.count", -1) do
      get :unjoin, id: @group4
    end

    assert_response :success
  end

  test "should create group" do
    assert_difference('Group.count') do
      post :create,
           group: {
             sport_id:    @group1.sport_id,
             description: @group1.description,
             name:        @group1.name
           }
    end

    assert_response :created
  end

  test "should create group and activity" do
    assert_difference(["Group.count", "Activity.count"]) do
      post :create,
           group: {
             sport_id:    @group1.sport_id,
             description: @group1.description,
             name:        @group1.name
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
    get :show, id: @group1
    assert_response :success

    assert_not_nil response.body
  end

  test "should update group" do
    patch :update, id: @group1,
          group: {
            sport_id:    @group1.sport_id,
            description: @group1.description,
            name:        @group1.name
          }
    assert_response :success
  end

  test "should destroy group" do
    # skip
    assert_difference('Group.count', -1) do
      delete :destroy, id: @group1
    end

    assert_response :success
  end

end
