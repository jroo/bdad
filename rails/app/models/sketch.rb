class Sketch < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :district
  
  def convert_screen_to_gis
    
  end
  
  def self.convert_svg_to_x_y_pairs(svg)
    split = svg.split(/[Ml]/).select{|x| ! x.empty? }
    split.collect!{|x| x.strip}
    pairs = split.collect{|x| x.split(" ").collect{|y| y.to_i }}
  end
  
  def svg
    hash = ActiveSupport::JSON.decode screen_data
    hash['map']['paths']
  end
  
  # def user_name
  #   user.name
  # end
  # 
  # def user_name=(value)
  #   user ||= User.find(self.user_id)
  #   if user
  #     # ...
  #   else
  #     user = User.find(self.user_id)
  #   end
  #   user.name = value
  #   user.save!
  # end
end
