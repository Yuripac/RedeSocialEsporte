require "test_helper"

class Api::V1::UsersControllerTest < ActionController::TestCase

  setup do
    @user = users(:one)

    request.headers['X-Api-Key'] = @user.api_key
  end

  test "should show user" do
    get :show, id: @user
    assert_response :success

    assert_not_nil response.body
  end

  test "should update user" do
    patch :update, id: @user, user: { name: @user.name, sport_id: @user.sport_id }
    assert_response :success
  end

end
