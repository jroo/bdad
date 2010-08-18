require 'test_helper'

class DistrictTest < ActiveSupport::TestCase
  test "find random" do
    assert District.find_random.is_a?(District)
  end
  
  test "find closest by zip" do
    actual = District.find_or_create_closest_by_zip(97209)
    assert actual.is_a?(District)
    assert actual.state == "OR"
    assert actual.number == "1"
  end
  
  
end
