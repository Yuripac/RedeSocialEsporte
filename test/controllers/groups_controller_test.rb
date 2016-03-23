require 'test_helper'

class GroupsControllerTest < ActionController::TestCase

  setup do
    @group1 = groups(:one)
    @group4 = groups(:four)

    # Needs this to use current_user
    session[:user_id] = users(:one).id
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:groups)
  end

  test "should get my" do
    get :my
    assert_response :success
    assert_not_nil assigns(:groups)
  end

  test "should get join" do
    assert_difference("Membership.count") do
      get :join, id: @group4
    end

    assert_redirected_to groups_path
  end

  test "should get unjoin" do
    get :join, id: @group4

    assert_difference("Membership.count", -1) do
      get :unjoin, id: @group4
    end

    assert_redirected_to groups_path
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create group" do
    assert_difference('Group.count') do
      post :create, group: { sport_id: @group1.sport_id, description: @group1.description, name: @group1.name }
    end

    assert_redirected_to group_path(assigns(:group))
  end

  test "should show group" do
    get :show, id: @group1
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @group1
    assert_response :success
  end

  test "should update group" do
    patch :update, id: @group1, group: { sport_id: @group1.sport_id, description: @group1.description, name: @group1.name }
    assert_redirected_to group_path(assigns(:group))
  end

  test "should destroy group" do
    # skip
    assert_difference('Group.count', -1) do
      delete :destroy, id: @group1
    end

    assert_redirected_to groups_path
  end
end
