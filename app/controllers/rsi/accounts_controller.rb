class Rsi::AccountsController < ApplicationController
  def create
    if request.env['omniauth.auth'].present?
      @user = OauthAccount.build_for_user(current_user, request.env['omniauth.auth'])
    else
      begin
        @user = User.build_user(params[:email])
      rescue Exception => e
        @user = nil
        flash[:error] = e.message
      end
    end
    
    unless @user.blank?
      sign_in @user
      
      if session[:activity_group].present?
        @user.join_group(session.delete(:activity_group))
      end
    
      if session[:sensor_uuid].present?
        @user.add_sensor(session.delete(:sensor_uuid))
      end
    end
    
    redirect_to rsi_portals_path 
  end
end
