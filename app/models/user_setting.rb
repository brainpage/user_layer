class UserSetting < ActiveRecord::Base
  belongs_to :user

  after_save :notify_switchboard
  
  def self.default_rsi_interval
    15
  end

  def notify_switchboard
    if self.rsi_interval.blank?
      self.update_attribute(:rsi_interval, self.class.default_rsi_interval)
    end
    
    for sensor in self.user.sensors.computer
      Switchboard.update_settings_for "sensor_computer", sensor.uuid
    end
  end

end
