class Rsi::GroupsController < ApplicationController
  before_filter :authenticate_user!, :except => [:join]
  
  def create
    group = current_user.create_activity_group
    redirect_to group.fb_invite_link
  end
  
  def join
    @group = ActivityGroup.find_by_code(params[:id])
    session[:activity_group] = params[:id] unless @group.blank?
  end
end
