require "test_helper"

class Api::V1::UsersControllerTest < ActionController::TestCase

  setup do
    @not_followed_user = users(:one)
    @current_user      = users(:two)
    @followed_user     = users(:three)

    request.headers['X-Api-Key'] = @current_user.api_key
  end

  test "should follows the user" do
    assert_difference("Relationship.count") do
      get :follow, id: @not_followed_user
    end

    assert_response :success
  end

  test "should fails when follows a followed user" do
    assert_no_difference("Relationship.count") do
      get :follow, id: @followed_user
    end

    assert_response :bad_request
  end

  test "should unfollows user" do
    assert_difference("Relationship.count", -1) do
      get :unfollow, id: @followed_user
    end

    assert_response :success
  end

  test "should fails when unfollow a not followed user" do
    assert_no_difference("Relationship.count") do
      get :unfollow, id: @not_followed_user
    end

    assert_response :bad_request
  end

  test "should show user" do
    get :show, id: @not_followed_user
    assert_response :success

    assert_not_nil response.body
  end

  test "should update user" do
    patch :update, id: @current_user,
          user: { name: @current_user.name, sport_id: @current_user.sport_id }
    assert_response :success
  end

end
