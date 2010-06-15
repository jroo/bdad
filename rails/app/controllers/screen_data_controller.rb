class ScreenDataController < ApplicationController

  def index
    sketch = get_sketch
    if sketch
      render :text => sketch.screen_data
    else
      render :text => "404", :status => 404
    end
  end
  
  def create
    sketch = get_sketch
    unless sketch
      render :text => "", :status => 404
      return
    end
    sketch.screen_data = params[:d]
    if sketch.save
      render :text => "200", :status => 200
    else
      render :text => "404", :status => 404
    end
  end

end
