class Rsi::ActivitiesController < ApplicationController
  before_filter :authenticate_user!, :except => [:invite, :join]
  
  def index
    @activities = current_user.activities
    @activity = @activities.first
    render :show unless @activity.blank?
  end
  
  def create
    act = current_user.create_activity(params[:time_span], params[:money_account])
    redirect_to act.fb_invite_link
  end
  
  def invite
    @activity = Activity.find_by_token(params[:token])
  end
  
  def join
    @activity = Activity.find_by_token(params[:id])
    unless @activity.blank?
      if current_user.blank?
        session[:target] = rsi_activities_path
        add_user_hook("join_activity", :join_activity, @activity.token)
        redirect_to "/auth/facebook"
      else
        current_user.join_activity(@activity.token)
        redirect_to rsi_activities_path
      end
    else
      render :text => "Bad request!", :status => 401
    end
  end
  
  def show
    @activity = current_user.activities.find_by_id(params[:id])
  end
  
end
