FIPS_FILENAME = "#{RAILS_ROOT}/lib/fips.csv"
array_of_arrays = FasterCSV.parse File.read(FIPS_FILENAME)

fips_code_for_state = {}
array_of_arrays.each do |array|
  fips_code_for_state[array[1]] = array[2]
end
FIPS_CODES = fips_code_for_state
