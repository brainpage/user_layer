class Rsi::FriendsController < ApplicationController
  before_filter :authenticate_user!, :except => [:follow, :join]
  
  def index
    @friends = [current_user] + current_user.friends
  end
  
  def invite
    if current_user.facebook.blank?
      session[:inviting_friend] = true
      redirect_to "/auth/facebook"
    else
      redirect_to user.fb_invite_link
    end
  end
  
  def follow
    @user = User.find_by_invite_token(params[:token])
    if current_user.blank?
      session[:target] = rsi_charts_path
      add_user_hook("accept_invite", :accept_invite, @user.invite_token)
    end
  end
  
  def join
    @user = User.find_by_invite_token(params[:id])
    unless @user.blank?
      if current_user.blank?
        redirect_to "/auth/facebook"
      else
        current_user.accept_invite(@user.token)
        redirect_to rsi_charts_path
      end
    else
      render :text => "Bad request!", :status => 401
    end
  end
end
