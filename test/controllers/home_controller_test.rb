require "test_helper"

class HomeControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers # Include Devise helpers

  setup do
    @user = users(:one) # Load the user fixture
    sign_in @user       # Sign in the user
  end

  test "should get index" do
    get root_url # Use root_url as defined in routes
    assert_response :success
  end
end
