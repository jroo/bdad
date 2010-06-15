class ScreenDataController < ApplicationController

  def index
    screen_data = ScreenData.find_by_token(params[:t])
    if screen_data
      render :text => screen_data.value
    else
      render :text => "404", :status => 404
    end
  end
  
  def create
    screen_data = ScreenData.find_or_create_by_token(params[:t])
    unless screen_data
      render :text => "", :status => 404
      return
    end
    screen_data.value = params[:d]
    if screen_data.save
      render :text => "200", :status => 200
    else
      render :text => "404", :status => 404
    end
  end

end
