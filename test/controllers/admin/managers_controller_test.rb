require 'test_helper'

class Admin::ManagersControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get admin_managers_index_url
    assert_response :success
  end

end
