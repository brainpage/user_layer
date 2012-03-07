class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :check_for_login_token
 before_filter :log_activity 

  def log_activity
    #We log the user's IP and computer info.  For matching purposes.
   
    if current_user
      logger.info "not here"
    end
  end

  def check_for_login_token
    if current_user
        if sensor_uuid = params.delete(:connect_to_sensor)
            Sensor.find_by_uuid(sensor_uuid).connect_to_user(current_user.id)
            redirect_to url_for(params)
        end
    end 
  end

end
