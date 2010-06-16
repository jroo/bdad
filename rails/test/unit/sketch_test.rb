require 'test_helper'

class SketchTest < ActiveSupport::TestCase
  test 'finds screen_data on save and copies paths' do
    sketch = Sketch.new({:token => 'ABCDE', :title => 'Test Title'})
    data = ScreenData.create!({
      :token => 'ABCDE', 
      :value => {'paths' => ['M 123 456 L 234 567z']}.to_json
    })
    sketch.save
    sketch.reload
    assert_equal %({"paths":["M 123 456 L 234 567z"]}), sketch.screen_data
    assert sketch.map_data.is_a?(MultiPolygon)
  end

end
