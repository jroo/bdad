class ScreenDataController < ApplicationController

  def index
    screen_data = ScreenData.find_by_token(params[:t])
    if screen_data
      render :text => response_hash(screen_data).to_json
    else
      render :text => "", :status => 404
    end
  end
  
  # POST /screen_data/?d=.....&t=12345&district_code=0601
  # An evil hybrid of create and update!
  def create
    screen_data = ScreenData.find_or_create_by_token(params[:t])
    unless screen_data
      render :text => "", :status => 404
      return
    end
    unless params[:district_code] && params[:d]
      render :text => "Need district_code and d", :status => 401
      return
    end
    screen_data.district_code = params[:district_code]
    decoded_d = ActiveSupport::JSON.decode(params[:d])
    screen_data.value = decoded_d['paths'].to_json
    if screen_data.save
      render :text => response_hash(screen_data).to_json, :status => 200
    else
      render :text => "", :status => 404
    end
  end
  
  protected
  
  def response_hash(screen_data)
    hash = {
      'district_code' => screen_data.district_code,
      'paths'         => screen_data.value,
      'population'    => 0, #some query we need (from Kevin)
      'awards'        => ["Gerry-manderest", "HomeTown"] #get query
    }
  end

end
