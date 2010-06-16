class ScreenData < ActiveRecord::Base
  before_save :populate_map_data
  
  def populate_map_data
    return unless value
    x_y_pairs = ScreenData.convert_svg_to_x_y_pairs(svg_from_json)
    self.map_data = MultiPolygon.from_coordinates(x_y_pairs)
  end
  
  def self.convert_svg_to_x_y_pairs(svg)
    split = svg.collect{|x| x.split(/[MLz]/).select{|y| ! y.empty? }}
    split.collect!{|x| x.collect{|y| y.strip.split(" ").collect{|z| z.to_i}}}
  end
  
  def svg_from_json
    hash = ActiveSupport::JSON.decode(self.value)
    hash['map']['paths']
  end
end
