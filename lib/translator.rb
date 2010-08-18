require 'rubygems'
require 'yaml'

class Converter

 # convert screen coordinates to map coordinates
 # sp = screen point
 # mp = map point
 def self.screen_to_map(sp, opts={})
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

 # convert map coordinates to screen coordinates
 # sp = screen point
 # mp = map point
 def self.map_to_screen(mp, opts={})
   x = if opts[:invert_x]
     (-mp[0] * opts[:scale]) + opts[:max_width]
   else
     (mp[0] + opts[:x_offset]) * opts[:scale]
   end
   y = if opts[:invert_y]
     (-mp[1] * opts[:scale]) + opts[:max_height]
   else
     (mp[1] * opts[:y_offset]) + opts[:scale]
   end
   [x, y]
 end
end

class Tester

 # SCREEN_POINTS = [
 #   [  0,   0],
 #   [640,   0],
 #   [320, 240],
 #   [  0, 480],
 #   [640, 480],
 # ]

 SCREEN_POINTS = [
   [424, 64],
 ]

 MAP_POINTS = [
   [2136036.1507436982, 9178000.762718998],
 ]

 OPTIONS = {
   :scale      => 0.00015651005959419845,
   :x_offset   => 579281.5732728788,
   :y_offset   => -6861939.218334042,
   :max_height => 1500.0000000000002,
   :max_width  => 650.3790323772871,
   :invert_x   => false,
   :invert_y   => true,
 }

 def self.test_map_to_screen
   MAP_POINTS.each do |mp|
     sp = Converter.map_to_screen(mp, OPTIONS)
     puts "---"
     puts "map    : #{mp.inspect}"
     puts "screen : #{sp.inspect}"
   end
 end

 def self.test_screen_to_map
   SCREEN_POINTS.each do |sp|
     mp = Converter.screen_to_map(sp, OPTIONS)
     puts "---"
     puts "screen : #{sp.inspect}"
     puts "map    : #{mp.inspect}"
   end
 end

end

Tester.test_map_to_screen
Tester.test_screen_to_map
