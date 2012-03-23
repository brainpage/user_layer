class Rsi::PortalsController < ApplicationController
  before_filter :check_for_sensor_info, :only => [:index]
  before_filter :authenticate_user!, :only => [:index]
  
  def index
    @feeds = current_user.feeds
  end
  
  def land
  end
  
  private
  def check_for_sensor_info
    if (uuid = params[:connect_to_sensor]).present? && Sensor.find_by_uuid(uuid).present?
      if current_user.blank? 
        add_user_hook(:sensor_uuid, :add_sensor, uuid) 
      else
        current_user.add_sensor(uuid)
      end
    end 
  end
end
