require 'test_helper'

class ScreenDataControllerTest < ActionController::TestCase
  test "can get existing screen data" do
    data = ScreenData.create({:value => '{map:{paths: [M123 456 L 234 345z]}}', :token => 'ABCDE'})
    get :index, :t => 'ABCDE'
    assert_response :success
  end
  
  test "can set screen data for an existing token" do
    data = ScreenData.create({:value => '{map:{paths: [M789 52 L 687 670]}}', :token => 'ABCDE'})
    post :create, :t => 'ABCDE', :d => '{map:{paths: [M123 456 L 234 345z]}}'
    assert_response :success
    data.reload
    assert_equal '{map:{paths: [M123 456 L 234 345z]}}', data.value
  end
  
  test "can set screen data for a new token" do
    post :create, :t => 'ABCDE', :d => '{map:{paths: [M123 456 L 234 345z]}}'
    assert_response :success
    data = ScreenData.find_by_token('ABCDE')
    assert_equal '{map:{paths: [M123 456 L 234 345z]}}', data.value
  end
  
  test "trying to get screen data for a missing sketch results in 404" do
    get :index, :t => 'DEFGH'
    assert_response :missing
  end
end
