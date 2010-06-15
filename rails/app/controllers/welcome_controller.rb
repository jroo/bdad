class WelcomeController < ApplicationController

  before_filter :current_user

  def index
    @page_title = "Welcome"
  end
  
  def locate_district
    raise "Need a zip" unless params[:zip]
    @district = District.find_closest_by_zip(params[:zip])
    raise "Could not find district" if @district.new_record?
    redirect_to new_sketch_path(:district_id => @district.id)
  end

  def clear_session
    session[:current_user_id] = nil
  end
  
end
