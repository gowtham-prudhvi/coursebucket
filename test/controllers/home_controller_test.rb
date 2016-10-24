require 'test_helper'

class HomeControllerTest < ActionDispatch::IntegrationTest
  test "should get catalog" do
    get home_catalog_url
    assert_response :success
  end

end
