class District < ActiveRecord::Base
  
  has_many :sketches
  
  def self.find_random
    District.new
  end
  
  def self.find_closest_by_zip(zip)
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
