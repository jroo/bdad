require 'test_helper'

class ScreenDataControllerTest < ActionController::TestCase
  test "can get existing screen data" do
    data = ScreenData.create({
      :value => {'paths' => ['M123 456 L 234 345z']}.to_json,
      :token => 'ABCDE'})
    get :index, :t => 'ABCDE'
    assert_response :success
  end
  
  test "can set screen data for an existing token" do
    data = ScreenData.create({
      :value => {'paths' => ['M789 52 L 687 670z']}.to_json,
      :token => 'ABCDE'
    })
    post :create, :t => 'ABCDE', :d => '{paths: [M123 456 L 234 345z]}'
    assert_response :success
    data.reload
    assert_equal %({paths: [M123 456 L 234 345z]}), data.value
  end
  
  test "can set screen data for a new token" do
    post :create, :t => 'ABCDE',
      :d => {'paths'=> ['M123 456 L 234 345z']}.to_json
    assert_response :success
    data = ScreenData.find_by_token('ABCDE')
    assert_equal({'paths' => ['M123 456 L 234 345z']}.to_json, data.value)
  end

  test "trying to get screen data for a missing sketch results in 404" do
    get :index, :t => 'DEFGH'
    assert_response :missing
  end
end
