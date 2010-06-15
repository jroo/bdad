class MapDataController < ApplicationController
  
  def index
    sketch = get_sketch
    if sketch
      render :text => sketch.map_data
    else
      render :text => "404", :status => 404
    end
  end
  
end
