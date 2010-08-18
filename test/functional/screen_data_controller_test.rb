require 'test_helper'

class ScreenDataControllerTest < ActionController::TestCase
  test "can get existing screen data" do
    data = ScreenData.create({
      :value         => ['M123 456 L 234 345z'].to_json,
      :token         => 'ABCDE',
      :district_code => "0601"
    })
    get :index, :t => 'ABCDE'
    assert_response :success
    response = parsed_response_body
    assert_equal response["district_code"], "0601"
    assert_equal response['paths'], ['M123 456 L 234 345z'].to_json
  end
  
  test "can set screen data for an existing token" do
    data = ScreenData.create({
      :value         => ['M789 52 L 687 670z'].to_json,
      :token         => 'ABCDE',
    })
    post :create, :t => 'ABCDE', :d => '{paths: [M123 456 L 234 345z]}', :district_code => "0601"
    assert_response :success
    response = parsed_response_body
    assert_equal "0601", response["district_code"]
    assert_equal ['M123 456 L 234 345z'].to_json, response['paths']
    data.reload
    assert_equal ["M123 456 L 234 345z"].to_json, data.value
  end

  test "can set screen data for a new token" do
    post :create,
      :t => 'ABCDE',
      :d => {'paths'=> ['M123 456 L 234 345z']}.to_json,
      :district_code => "0601"
    assert_response :success
    response = parsed_response_body
    assert_equal "0601", response["district_code"]
    assert_equal ['M123 456 L 234 345z'].to_json, response['paths']

    data = ScreenData.find_by_token('ABCDE')
    assert_equal(['M123 456 L 234 345z'].to_json, data.value)
  end
  
  test "trying to get screen data for a missing sketch results in 404" do
    get :index, :t => 'DEFGH'
    assert_response :missing
  end
end
