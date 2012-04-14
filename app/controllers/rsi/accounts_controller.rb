class Rsi::AccountsController < ApplicationController
  def create
    if request.env['omniauth.auth'].present?
      @user = OauthAccount.build_for_user(current_user, request.env['omniauth.auth'])
    else
      begin
        @user = User.build_user(params)
      rescue Exception => e
        @user = nil
        flash[:error] = e.message
      end
    end
    
    unless @user.blank?
      sign_in @user     
      call_user_hook(@user)
    end
    
    redirect_to rsi_portals_path 
  end
  
  def check
    render :text => User.find_by_email(params[:value]).blank? ? 0 : 1
  end
end
