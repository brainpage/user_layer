class Rsi::ChartsController < ApplicationController
  def index
    
  end
  
  def data

    render :json => ClientEvent.all.to_json
  end
end
