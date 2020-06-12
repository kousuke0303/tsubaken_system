require 'test_helper'

class Admin::AdminsControllerTest < ActionDispatch::IntegrationTest
  test "should get top" do
    get admin_admins_top_url
    assert_response :success
  end

end
