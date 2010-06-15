require 'test_helper'

class SketchTest < ActiveSupport::TestCase
  test "convert svg to x y pairs" do
    assert_equal(
      [[281, 200], [-5, 2], [-16, 7]], 
      Sketch.convert_svg_to_x_y_pairs("M 281 200 l -5 2 l -16 7")
    )
  end
  
  test "extract svg portion from screen data json" do
    json = '{map: {paths:[M 281 200 l -5 2 l -16 7 l -9 8 l -1 9 l 0 4 l 5 7 l 6 8 l 7 7 l 4 3 l 7 5 l 15 5 l 29 7 l 24 3 l 11 1 l 8 0 l 10 -1 l 9 -5 l 7 -4 l 4 -5 l 0 -10 l 0 -7 l 0 -4 l -2 -8 l -2 -7 l -2 -5 l -5 -5 l -7 -5 l -5 -5 l -10 -5 l -7 -2 l -2 0 l -4 0 l -12 0 l -8 0 l -5 1 l -3 0 l -1 1 l -1 0 l -2 1 l -1 0 l -1 0 l -6 0 l -5 0 l -5 0 l -4 1 l -4 0 l -2 0 l -1 0 l -1 0 l -1 0 l -1 0 l -1 0 l -4 -1 l -3 0]}}'
    sketch = Sketch.create({:title => 'Test', :screen_data => json})
    assert_equal(
      ["M 281 200 l -5 2 l -16 7 l -9 8 l -1 9 l 0 4 l 5 7 l 6 8 l 7 7 l 4 3 l 7 5 l 15 5 l 29 7 l 24 3 l 11 1 l 8 0 l 10 -1 l 9 -5 l 7 -4 l 4 -5 l 0 -10 l 0 -7 l 0 -4 l -2 -8 l -2 -7 l -2 -5 l -5 -5 l -7 -5 l -5 -5 l -10 -5 l -7 -2 l -2 0 l -4 0 l -12 0 l -8 0 l -5 1 l -3 0 l -1 1 l -1 0 l -2 1 l -1 0 l -1 0 l -6 0 l -5 0 l -5 0 l -4 1 l -4 0 l -2 0 l -1 0 l -1 0 l -1 0 l -1 0 l -1 0 l -4 -1 l -3 0"],
      sketch.svg
    )
  end
  
  test "convert relative pairs to absolute" do
    
  end
end
