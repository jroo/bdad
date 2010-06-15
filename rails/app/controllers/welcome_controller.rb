class WelcomeController < ApplicationController

  before_filter :current_user

  def index
    redirect_to new_sketch_path
  end
  
end
