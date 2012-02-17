class Api::FeedsController < ApplicationController
  def create
    @user = App.find_by_app_token(params[:app_id]).owner
    Feed.create(:app_id=>params[:app_id], :event_id => params[:event_id], :event=>params[:event], :user_id => @user.id)
    render :text=>'hi'
  end
end
