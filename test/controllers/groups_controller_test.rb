require 'test_helper'

class GroupsControllerTest < ActionController::TestCase

  setup do
    @group1 = groups(:one)
    @group2 = groups(:two)

    # Needs this to use current_user
    @request.session[:user_id] = users(:one).id
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:groups)
  end

  test "should get my groups" do
    get :my
    assert_response :success
    assert_not_nil assigns(:groups)
  end

  test "should join group" do
    assert_difference("Member.count") do
      get :join, id: @group2
    end

    assert_redirected_to groups_path
  end

  test "should unjoin group" do
    get :join, id: @group2

    assert_difference("Member.count", -1) do
      get :unjoin, id: @group2
    end

    assert_redirected_to groups_path
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create group" do
    assert_difference('Group.count') do
      post :create, group: { sport: @group1.sport, description: @group1.description, name: @group1.name }
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
    patch :update, id: @group1, group: { sport: @group1.sport, description: @group1.description, name: @group1.name }
    assert_redirected_to group_path(assigns(:group))
  end

  test "should destroy group" do
    assert_difference('Group.count', -1) do
      delete :destroy, id: @group1
    end

    assert_redirected_to groups_path
  end
end
