
class Api::V1::SportsControllerTest < ActionController::TestCase

  test "should get index" do
    get :index
    assert_response :success
  end

end
