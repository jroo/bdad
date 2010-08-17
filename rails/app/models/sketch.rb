# create_table "sketches", :force => true do |t|
#   t.column "title", :string
#   t.column "user_id", :integer
#   t.column "district_id", :integer
#   t.column "created_at", :datetime
#   t.column "updated_at", :datetime
#   t.column "screen_data", :text
#   t.column "map_data", :geometry, :srid => nil
#   t.column "token", :string, :limit => 40
# end

class Sketch < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :district
  
  before_save :get_path_data
  
  def get_path_data
    screen_data = ScreenData.find_by_token(token)
    unless screen_data
      raise "ScreenData not found for token : #{token}"
    end
    self.screen_data = screen_data.value
    self.map_data = screen_data.map_data
  end
end
