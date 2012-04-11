class UserSetting < ActiveRecord::Base
  belongs_to :user
  
  def self.default_rsi_interval
    15
  end
end
