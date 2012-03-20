class Rsi::PortalsController < ApplicationController
  before_filter :check_for_sensor_info, :only => [:index]
  before_filter :authenticate_user!, :only => [:index]
  
  def index
    
  end
  
  def land
  end
  
  private
  def check_for_sensor_info
    if (uuid = params.delete(:connect_to_sensor)).present? && Sensor.find_by_uuid(uuid).present?
       session[:sensor_uuid] = uuid
    end 
  end
end
