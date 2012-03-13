class Rsi::PortalsController < ApplicationController
  def index
    if current_user.blank?
      render :action => :land
    end
  end
  
  def land
  end
end
