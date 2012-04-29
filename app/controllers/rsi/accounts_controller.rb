class Rsi::AccountsController < ApplicationController
  def create
    if request.env['omniauth.auth'].present?
      @user = OauthAccount.build_for_user(current_user, request.env['omniauth.auth'])
      if session.delete(:inviting_friend)
        redirect_to (weibo? ? rsi_friends_path(:share => true) : @user.fb_invite_link) and return
      end
    else
      @user = User.find_by_email(params[:email])
      if @user.present? and @user.valid_password?(params[:password])
        sign_in @user
        redirect_to rsi_charts_path and return
      else
        @user = User.create(:email => params[:email], :password => params[:password], :password_confirmation => params[:password])
      end
    end
    
    if @user.errors.blank?
      sign_in @user     
      call_user_hook(@user)
      redirect_to rsi_charts_path
    else
      flash[:error] = @user.errors.full_messages.join("<br />")
      redirect_to "/signin"
    end
  end
  
  def check
    render :text => User.find_by_email(params[:value]).blank? ? 0 : 1
  end
  
  def pwd
    if current_user.update_attributes(params) 
      flash[:notice] = "Update successfully!"
      sign_in current_user
    else
      flash[:notice] = current_user.errors[:password]
    end
    redirect_to rsi_settings_path
  end
end
