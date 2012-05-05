class Rsi::Admin::UsersController < ApplicationController
  before_filter :authenticate_admin!
  
  def index
    @users = User.order("id desc")
  end
  
  private
  def authenticate_admin!
    render :text => "Access Denied!", :status => :unauthorized unless current_user.is_a?(AdminUser)
  end
end
