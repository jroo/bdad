class Sketch < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :district
  
  before_save :get_path_data
  
  def get_path_data
    screen_data = ScreenData.find_by_token(self.token)
    self.screen_data, self.map_data = screen_data.value, screen_data.map_data
  end
end
