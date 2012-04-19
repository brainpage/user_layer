class Rsi::SettingsController < ApplicationController
  before_filter :check_sensor_hook, :only => [:index]
  before_filter :authenticate_user!
  before_filter :find_setting
  
  def create
    if params[:value].to_i <= 60
      @setting.update_attribute(:rsi_interval, params[:value])
    end
    render :nothing => true
  end
  
  def alert
    @setting.update_attribute(:send_alert, !@setting.send_alert)
    redirect_to :action => :index
  end
  
  private
  def find_setting
    @setting = current_user.setting || UserSetting.create(:user => current_user)
  end
end
