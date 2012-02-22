class FeedsController < ApplicationController
  before_filter :authenticate_user!, :except=>:create
  def index
    @feeds = current_user.feeds.since(params[:since])
    #Feed.create(:event => "Hello hello")
    render :json => @feeds.to_json
  end
end
