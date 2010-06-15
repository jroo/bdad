require 'test_helper'

class ScreenDataControllerTest < ActionController::TestCase
  test "can get screen data for an existing sketch" do
    sketch = Sketch.create({:title => 'Test 1', :screen_data => '123'})
    get :index, :sketch_id => sketch.id
    assert_response :success
  end
  
  test "can set screen data on an existing sketch" do
    sketch = Sketch.create({:title => 'Test 1', :screen_data => '123'})
    post :create, :sketch_id => sketch.id, :d => 456
    assert_response :success
    sketch.reload
    assert sketch.screen_data.to_i == 456
  end
  
  test "trying to get screen data for a missing sketch results in 404" do
    get :index, :sketch_id => 12
    assert_response :missing
  end
    
  test "trying to set screen data for a missing sketch results in 404" do
    post :create, :sketch_id => 12
    assert_response :missing
  end
end
