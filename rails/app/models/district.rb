# create_table "districts", :force => true do |t|
#   t.string   "state"
#   t.string   "number"
#   t.datetime "created_at"
#   t.datetime "updated_at"
# end

class District < ActiveRecord::Base
  
  # state is a two letter code
  
  has_many :sketches
  
  # Two digits for state + Two digits for district
  # For example, "3301":
  # 33 = New Hampshire
  # 01 = 1st District
  # (from http://www.cs.princeton.edu/introcs/data/codes.csv)
  def code
    "%02i%02i" % [FIPS_CODES[state], number]
  end
  
  def self.find_random
    district = District.first
    raise "FAIL" unless district
    district
  end
  
  def self.find_or_create_closest_by_zip(zip)
    districts = Sunlight::District.all_from_zipcode(zip)
    raise "API lookup failed for districts for zip #{zip}" unless districts
    district = best_district(districts)
    state, number = district.state, district.number
    District.find_or_create_by_number_and_state(number, state)
  end
  
  protected
  
  # TODO: calculate best district, not necessarily the first
  def self.best_district(districts)
    raise "No districts found for that zip code" if districts.empty?
    district = districts.first
    district
  end
  
end
