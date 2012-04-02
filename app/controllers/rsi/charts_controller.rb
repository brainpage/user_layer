class Rsi::ChartsController < ApplicationController
  def index
    
  end
  
  def data
    if params[:type] == "bar"
      render :json => [{:name => "firefox", :value => 100}, {:name => "vmware", :value => 200}, {:name => "qq", :value => 150}].to_json
    else
      render :json => ClientEvent.day(params[:day] || 0).to_json
    end
  end
end
