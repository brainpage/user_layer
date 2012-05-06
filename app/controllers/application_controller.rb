class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :weibo?
  include UserHook
  
  before_filter :set_locale 

  before_filter :log_session
  def log_session
    logger.info "Session: #{session.inspect}"
  end
  
  def weibo?
    I18n.locale.to_s == "zh"
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
    locale = session[:locale]
    if locale.blank?
      @geoip ||= GeoIP.new(Rails.root.join("db/GeoIP.dat"))
      locale = @geoip.country("123.125.114.144").try(:country_name) == "China" ? :zh : :en
    end
    I18n.locale = locale
  end
end
