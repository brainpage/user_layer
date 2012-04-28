class Rsi::PortalsController < ApplicationController
  before_filter :check_sensor_hook, :only => [:index]
  before_filter :authenticate_user!, :only => [:index]
  
  def index
    @feeds = current_user.feeds
    @uuid = current_user.sensor_uuid
  end
  
  def land
    render :layout => false
  end
 
end
