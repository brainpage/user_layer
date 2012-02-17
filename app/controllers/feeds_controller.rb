class FeedsController < ApplicationController
  before_filter :authenticate_user!, :except=>:create
  def index
    @feeds = current_user.feeds.all(:limit=>10)
  end
end
