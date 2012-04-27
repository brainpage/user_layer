class Rsi::RelationsController < ApplicationController
  before_filter :authenticate_user!
  
  def update
    accept = params[:accept]
    @feed = current_user.feeds.find_by_id(params[:id])
    
    @feed.originator.update_attribute(:confirmed => accept)
    @feed.destroy
    current_user.feeds.create(:xtype => accept ? :accept_request, :referer => @feed.referer)
    redirect_to rsi_portals_path
  end

end
