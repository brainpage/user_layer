class FeedsController < ApplicationController
  #before_filter :authenticate_user!, :except=>:create
  def index
    #@feeds = current_user.feeds.all(:limit=>10)
    Feed.create(:event => "Hello hello")
    render :json => Feed.all.to_json
  end
end
