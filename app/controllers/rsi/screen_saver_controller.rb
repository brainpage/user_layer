class Rsi::ScreenSaverController < ApplicationController
  layout :false
  
  def index
    @uuid = params[:uuid] || params[:connect_to_sensor]
  end
end
