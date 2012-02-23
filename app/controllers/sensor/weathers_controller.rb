class Sensor::WeathersController < ApplicationController
  before_filter :authenticate_user!
  
 
  def geocode
    @locations = Geocoder.encode(params[:sensor][:location])
    render :layout=>false
  end
 def new

  end
  def create
    uid = (params[:lat].to_f * 100).to_i.to_s + "-" + (params[:lng].to_f * 100).to_i.to_s
    @sensor = current_user.sensors.new(:description=>params[:description], :stype=>"weather", :uid=>uid, :public=>true)
    if @sensor.save
      flash[:notice] = "Successfully created weather sensor"
      redirect_to cares_path
    else
      flash[:error] = "Error creating weather sensor"
      render :action=>:new
    end
  end

end
