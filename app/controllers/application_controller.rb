class ApplicationController < ActionController::Base
  protect_from_forgery
  include UserHook
  
  #before_filter :log_activity 

  def log_activity
    #We log the user's IP and computer info.  For matching purposes.
   
    if current_user
      logger.info "not here"
    end
  end

  protected
  def check_sensor_hook
    if (uuid = params[:connect_to_sensor]).present? && Sensor.find_by_uuid(uuid).present?
      if current_user.blank? 
        add_user_hook(:sensor_uuid, :add_sensor, uuid) 
      else
        current_user.add_sensor(uuid)
      end
    end 
  end
end
