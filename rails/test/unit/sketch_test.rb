require 'test_helper'

class SketchTest < ActiveSupport::TestCase
  test 'finds screen_data on save and copies paths' do
    sketch = Sketch.new({:token => 'ABCDE', :title => 'Test Title'})
    data = ScreenData.create({
      :token => 'ABCDE', 
      :value => '{map: {paths: [M 123 456 L 234 567z]}}'
    })
    sketch.save
    sketch.reload
    assert_equal '{map: {paths: [M 123 456 L 234 567z]}}', sketch.screen_data
    assert_equal MultiPolygon.from_coordinates([[[123,456], [234,567]]]), sketch.map_data
  end

end
