class FeedsController < ApplicationController
    layout 'things'

  before_filter :authenticate_user!, :except=>:create
  def index
    @feeds = current_user.feeds.since(params[:since])
    #Feed.create(:event => "Hello hello")
  end

end
