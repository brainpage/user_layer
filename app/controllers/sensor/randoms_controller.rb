class Sensor::RandomsController < ApplicationController
  before_filter :authenticate_user!
  def new

  end
  def create
    uid = params[:sensor][:min] + "-" + params[:sensor][:max] + "-" + params[:sensor][:frequency] + "-0-" + Sensor.generate_uid
   @sensor = current_user.sensors.new(:description => "#{params[:sensor][:min]}-#{params[:sensor][:max]} every #{params[:sensor][:frequency]}s", :stype=>"random", :uid=>uid, :public=>false)
    if @sensor.save
      flash[:notice] = "Successfully created randomness sensor"
      redirect_to sensors_path
    else
      flash[:error] = "Error creating randomness sensor"
      render :action => :new
    end 
  end
end
