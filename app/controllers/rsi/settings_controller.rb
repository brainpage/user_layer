class Rsi::SettingsController < ApplicationController
  before_filter :authenticate_user!
  
  def create
    if params[:value].to_i <= 60
      (current_user.setting || UserSetting.create(:user => current_user)).update_attribute(:rsi_interval, params[:value])
    end
    render :nothing => true
  end
end
