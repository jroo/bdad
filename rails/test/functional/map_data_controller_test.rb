require 'test_helper'

class MapDataControllerTest < ActionController::TestCase
  test "can get gis data for an existing sketch" do
    sketch = Sketch.create({:title => 'Test 1', :screen_data => '123'})
    get :index, :sketch_id => sketch.id
    assert_response :success
  end
  
  test "trying to get gis data for a missing sketch results in 404" do
    get :index, :sketch_id => 12
    assert_response :missing
  end
end
