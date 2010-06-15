class SketchesController < ApplicationController
  
  before_filter :current_user
  
  def index
    @sketches = Sketch.all
  end
  
  def new
    @district = if params[:district_id]
      District.find(params[:district_id])
    else
      District.find_random
    end
    @sketch = Sketch.new({
      :title       => "Draw Me a District for a Great Good",
      :user_id     => current_user.id,
      :district_id => @district.id
    })
  end
  
  def create
    user = current_user
    user.name = params[:user_name]
    user.save!
    @sketch = Sketch.create!(params[:sketch])
    redirect_to sketch_path(@sketch)
  end
  
  def update
  end
  
  def show
    @sketch = Sketch.find(params[:id])
    @district = @sketch.district
  end
  
  def locate_district
    raise "Need a zip" unless params[:zip]
    @district = District.find_closest_by_zip(params[:zip])
    raise "Could not find district" if @district.new_record?
    redirect_to new_sketch_path(:district_id => @district.id)
  end
  
  protected
  
end
