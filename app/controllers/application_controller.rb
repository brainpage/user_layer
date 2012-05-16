class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :zh?, :current_sensor
  include UserHook
  
  before_filter :set_locale 

  before_filter :log_session
  def log_session
    logger.info "Session: #{session.inspect}"
  end
  
  def zh?
    I18n.locale.to_s == "zh"
  end
  
  def current_sensor
    (id = session[:current_sensor_uuid]).blank? ? current_user.rsi_sensors.first : current_user.rsi_sensors.find_by_uuid(id)
  end

  protected
  def check_sensor_hook
    if (uuid = params[:connect_to_sensor]).present? && Sensor.find_by_uuid(uuid).present?
      if current_user.blank? 
        add_user_hook(:sensor_uuid, :add_sensor, uuid) 
      else
        current_user.add_sensor(uuid)
      end
      session[:setup_done] = true
    end 
  end
  
  def set_locale
    if Rails.env.production?
      I18n.locale = (request.domain =~ /brainpage.cn/ or request.domain =~ /http:\/\/rsi/) ? :zh : :en      
    else
      I18n.locale = session[:locale] || :en
    end
  end
end
