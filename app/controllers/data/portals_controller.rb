class Data::PortalsController < ApplicationController
  layout "dashboard"
  
  def index
  end
  
  def land
    render :layout => "data"
  end
end
