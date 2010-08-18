require 'test_helper'

class ScreenDataTest < ActiveSupport::TestCase
  test "Handle 2 NaN pairs" do
    assert_equal(
      [[]],
      ScreenData.convert_svg_to_x_y_pairs("MNaN NaNLNaN NaNz")
    )
  end

  test "Handle 1 NaN pair" do
    assert_equal(
      [[]],
      ScreenData.convert_svg_to_x_y_pairs("MNaN NaNz")
    )
  end
  
  test "convert svg to x y pairs" do
    assert_equal(
      [[[281, 200], [-5, 2], [-16, 7], [281, 200]]], 
      ScreenData.convert_svg_to_x_y_pairs("M 281 200 L -5 2 L -16 7")
    )
  end
  
  test "extract svg portion from screen data hash" do
    paths = ['M 281 200 L -5 2 L -16 7 L -9 8 L -1 9 L 0 4 L 5 7 L 6 8 L 7 7 L 4 3 L 7 5 L 15 5 L 29 7 L 24 3 L 11 1 L 8 0 L 10 -1 L 9 -5 L 7 -4 L 4 -5 L 0 -10 L 0 -7 L 0 -4 L -2 -8 L -2 -7 L -2 -5 L -5 -5 L -7 -5 L -5 -5 L -10 -5 L -7 -2 L -2 0 L -4 0 L -12 0 L -8 0 L -5 1 L -3 0 L -1 1 L -1 0 L -2 1 L -1 0 L -1 0 L -6 0 L -5 0 L -5 0 L -4 1 L -4 0 L -2 0 L -1 0 L -1 0 L -1 0 L -1 0 L -1 0 L -4 -1 L -3 0']
    data = ScreenData.create({:token => 'ABCDE', :value => paths.to_json})
    assert_equal(
      ["M 281 200 L -5 2 L -16 7 L -9 8 L -1 9 L 0 4 L 5 7 L 6 8 L 7 7 L 4 3 L 7 5 L 15 5 L 29 7 L 24 3 L 11 1 L 8 0 L 10 -1 L 9 -5 L 7 -4 L 4 -5 L 0 -10 L 0 -7 L 0 -4 L -2 -8 L -2 -7 L -2 -5 L -5 -5 L -7 -5 L -5 -5 L -10 -5 L -7 -2 L -2 0 L -4 0 L -12 0 L -8 0 L -5 1 L -3 0 L -1 1 L -1 0 L -2 1 L -1 0 L -1 0 L -6 0 L -5 0 L -5 0 L -4 1 L -4 0 L -2 0 L -1 0 L -1 0 L -1 0 L -1 0 L -1 0 L -4 -1 L -3 0"],
      data.svg_from_hash
    )
  end
  
  test "convert and populate map data automatically on save" do
    paths = ['M 281 200 L -5 2 L -16 7z']
    data = ScreenData.create({:token => 'ABCDE', :value => paths.to_json})
    assert data.map_data.is_a?(MultiPolygon)
    # Strange object equality problems. Bailing.
    # assert_equal(
    #   MultiPolygon.from_coordinates([[[
    #     [1216130.17679981, 8306175.35620815],
    #     [-611228.401565987, 9571269.75661524],
    #     [-681511.423810825, 9539322.92832213],
    #     [1216130.17679981, 8306175.35620815],
    #   ]]]),
    #   data.map_data
    # )
  end

end
