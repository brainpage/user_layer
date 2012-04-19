class Rsi::PortalsController < ApplicationController
  before_filter :check_sensor_hook, :only => [:index]
  before_filter :authenticate_user!, :only => [:index]
  
  def index
    @feeds = current_user.feeds
  end
  
  def land
  end
  
  
end
