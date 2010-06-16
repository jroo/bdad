class ScreenData < ActiveRecord::Base
  before_save :populate_map_data
  
  # path is an array of points
  # a point is [x, y]
  def populate_map_data
    return unless value
    screen_paths = self.class.convert_svg_to_x_y_pairs(svg_from_hash)
    map_paths = self.class.screen_paths_to_map_paths(screen_paths)
    self.map_data = MultiPolygon.from_coordinates([map_paths]) # ???
  end
  
  # Q: What kind of XY pairs?
  # An array with arrays in it.
  # Obviously, still screen data.
  #
  # convert SVG string to:
  # [
  #   [ [20, 30], [25, 45] ],
  #   [ [60, 40], [65, 65] ]
  # ]
  # svg => "M416 300L416 300L416 299L416 299z"
  #
  # better name (I think)
  # def self.convert_svg_to_paths(svg)
  def self.convert_svg_to_x_y_pairs(svg)
    split = svg.collect do |x|
      x.split(/[MLz]/).select{|y| ! y.empty? }
    end
    # split => ["416 300", "416 300", "416 299", "416 299"]
    paths = split.collect do |x|
      pairs = x.collect do |y|
        space_delimited = y.strip.split(" ")
        # space_delimited => [["416", "300"], [["416", "300"]...
        filtered = space_delimited.select { |x| x != "NaN" }
        filtered.collect { |z| z.to_i }
      end
      pairs.select { |x| ! x.empty? }
    end
    # paths => [[[416, 300], [416, 300], [416, 299], [416, 299]]]
    valid_paths = paths.select do |path|
      !path.empty?
    end
    valid_paths.map do |path|
      # path => [[416, 300], [416, 300], [416, 299], [416, 299]]
      path << path[0]
    end
    paths
  end
  
  def svg_from_hash
    ActiveSupport::JSON.decode(self.value)
  end
  
  protected
  
  OPTIONS = {
    :scale      => 0.00015651005959419845,
    :x_offset   => 579281.5732728788,
    :y_offset   => -6861939.218334042,
    :max_height => 1500.0000000000002,
    :max_width  => 650.3790323772871,
    :invert_x   => false,
    :invert_y   => true,
  }
  
  def self.screen_paths_to_map_paths(paths)
    paths.map do |path|
      screen_points_to_map_points(path)
    end
  end
  
  def self.screen_points_to_map_points(points)
    points.map do |point|
      screen_point_to_map_point(point, OPTIONS)
    end
  end
  
  # convert screen coordinates to map coordinates
  # sp = screen point
  # mp = map point
  def self.screen_point_to_map_point(sp, opts={})
    x = if opts[:invert_x]
      -(sp[0] - opts[:max_width]) / opts[:scale]
    else
      (sp[0] / opts[:scale]) - opts[:x_offset]
    end
    y = if opts[:invert_y]
      -(sp[1] - opts[:max_height]) / opts[:scale]
    else
      (sp[1] / opts[:scale]) / opts[:y_offset]
    end
    [x, y]
  end
  
end
