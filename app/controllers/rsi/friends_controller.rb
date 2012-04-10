class Rsi::FriendsController < ApplicationController
  before_filter :authenticate_user!, :except => [:invite, :join]
  
  def index
    @friends = current_user.friends
  end
  
  def invite
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
