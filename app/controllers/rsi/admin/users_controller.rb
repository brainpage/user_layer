class Rsi::Admin::UsersController < ApplicationController
  before_filter :authenticate_admin!
  
  def index
    @users = User.order("id desc")
  end
  
  def inspect
    session[:inspector_id] = current_user.id
    sign_in User.find_by_id(params[:id])
    redirect_to rsi_charts_path
  end
  
  def uninspect
    sign_in AdminUser.find_by_id(session.delete(:inspector_id))
    redirect_to rsi_admin_users_path
  end
  
  def destroy
    User.find_by_id(params[:id]).try(:destroy)
    redirect_to :action => :index
  end
  
  private
  def authenticate_admin!
    render :text => "Access Denied!", :status => :unauthorized unless session[:inspector_id].present? or current_user.is_a?(AdminUser)
  end
end
