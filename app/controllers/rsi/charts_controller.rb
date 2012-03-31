class Rsi::ChartsController < ApplicationController
  def index
    
  end
  
  def data

    render :json => ClientEvent.day(params[:day] || 0).to_json
  end
end
