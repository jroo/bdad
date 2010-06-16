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
    unless state_fips && number
      raise "Cannot construct 4 digit code without state_fips && number"
    end
    # "%02i%02i" % [state_fips.to_i, number.to_i]
    four_digit_code = state_fips + number
    puts "\n\n--- #{four_digit_code}"
    four_digit_code
  end
  
  def self.find_random
    District.find :first, :offset => rand(District.count)
  end

  # 1807 # 
  # 3711 # 
  # 4818 # emoticon
  # 0802 # Dragon
  # 1703 # space invaders
  # 0637 # dog
  # 1308 # grandpa. add cane
  # 2502 # Twitter fail whale
  # 1205 # a head leaning back
  # 3412 # 
  # 0611 # turkey
  # 5110 # 
  DISTRICTS = %w(0611 1807 3711 4818 0802 1703 0637 1308 2502 1205 3412 5110)
  
  def self.find_fun_random
    $counter ||= 0
    $counter += 1
    index = $counter % DISTRICTS.length
    code = DISTRICTS[index]
    s = code[0, 2]
    n = code[2, 2]
    puts "s : #{s.inspect}"
    puts "n : #{n.inspect}"
    d = District.find_by_state_fips_and_number(s, n)
    puts d.inspect
    d
  end
  
  def self.find_or_create_closest_by_zip(zip)
    districts = Sunlight::District.all_from_zipcode(zip)
    raise "API lookup failed for districts for zip #{zip}" unless districts
    district = best_district(districts)
    state, number = district.state, district.number
    District.find_by_number_and_state(number, state)
  end
  
  protected
  
  # TODO: calculate best district, not necessarily the first
  def self.best_district(districts)
    raise "No districts found for that zip code" if districts.empty?
    district = districts.first
    district
  end
  
end
