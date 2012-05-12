class Rsi::ChartsController < ApplicationController
  before_filter :check_sensor_hook, :only => [:index]
  before_filter :authenticate_user!, :only => [:index]
  
  def index
    @uuid = current_sensor.try(:uuid)
  end
  
  def active
    session[:current_sensor_uuid] = params[:id] unless current_user.rsi_sensors.find_by_uuid(params[:id]).blank?
    redirect_to :action => :index
  end
  
  def average
    render :json => ProcessedData.all_time.to_json
  end
  
  def percent
    hash = {}
    %w{keys msclks dst scrll}.each do |i|
      hash[i] = Percentile.of("#{i}:all:#{Time.now.to_date().to_s()}", params[i])
    end
    render :json => hash.to_json
  end
end
