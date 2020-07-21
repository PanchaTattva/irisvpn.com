require 'test_helper'

class PricingControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get pricing_index_url
    assert_response :success
  end

end
