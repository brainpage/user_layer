class Rsi::FriendsController < ApplicationController
  before_filter :authenticate_user!, :except => [:follow, :join]
  
  def index
    @friends = [current_user] + current_user.friends
  end
  
  # Force user to bind social account before inviting friends.
  def invite
    if current_user.active_oauth_account.blank?
      session[:inviting_friend] = true
      redirect_to zh? ? "/auth/weibo" : "/auth/facebook"
    else
      redirect_to current_user.fb_invite_link
    end
  end
  
  def weibo
    current_user.change_settings(:allow_stranger => params[:allow].to_i)
    current_user.send_weibo(params[:content])
    redirect_to :action => :index
  end
  
  def follow
    @user = User.find_by_invite_token(params[:token])
    if @user.blank?
      render :text => "Bad request!", :status => 401
    else
      if current_user.blank?
        session[:invite_token] = @user.invite_token
        add_user_hook("follow_invite", :follow_invite, @user.invite_token)
        redirect_to home_path
      else
        accept_invite_and_redirect(@user.invite_token)
      end
    end   
  end
  
  def join
    @user = User.find_by_invite_token(params[:id])
    if @user.blank?
      render :text => "Bad request!", :status => 401
    else
      current_user.blank? ? redirect_to("/auth/facebook") : accept_invite_and_redirect(@user.invite_token)
    end
  end
  
  private 
  def accept_invite_and_redirect(inviter_token)
    current_user.follow_invite(inviter_token)
    redirect_to rsi_portals_path
  end
end
