require "test_helper"

class Api::V1::GroupsControllerTest < ActionController::TestCase

  setup do
    @group1 = groups(:one)
    @group2 = groups(:two)

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

  test "should get join" do
    assert_difference("Member.count") do
      get :join, id: @group2
    end

    assert_response :success
  end

  test "should get unjoin" do
    get :join, id: @group2

    assert_difference("Member.count", -1) do
      get :unjoin, id: @group2
    end

    assert_response :success
  end

  test "should create group" do
    assert_difference('Group.count') do
      post :create, group: { sport: @group1.sport, description: @group1.description, name: @group1.name }
    end

    assert_response :created
  end

  test "should show group" do
    get :show, id: @group1
    assert_response :success

    assert_not_nil response.body
  end

  test "should update group" do
    patch :update, id: @group1, group: { sport: @group1.sport, description: @group1.description, name: @group1.name }
    assert_response :success
  end

  test "should destroy group" do
    assert_difference('Group.count', -1) do
      delete :destroy, id: @group1
    end

    assert_response :success
  end

end
