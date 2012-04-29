class Rsi::SettingsController < ApplicationController
  before_filter :check_sensor_hook, :only => [:index]
  before_filter :authenticate_user!, :except => [:locale]
  
  def create
    if params[:value].to_i <= 60
      current_user.change_settings(:rsi_interval => params[:value].to_i)
    end
    render :nothing => true
  end
  
  def alert
    current_user.change_settings(:send_alert => !current_user.setting.send_alert)
    redirect_to :action => :index
  end
  
  def locale
    session[:locale] = I18n.locale = params[:locale].to_sym
    redirect_to :back
  end
end
