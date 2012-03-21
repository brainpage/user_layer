class Rsi::ActivitiesController < ApplicationController
  before_filter :authenticate_user!
  
  def create
    act = current_user.create_activity(params[:time_span], params[:money_account])
    redirect_to act.fb_invite_link
  end
  
end
