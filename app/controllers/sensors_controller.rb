require 'digest/sha1'
class SensorsController < ApplicationController
  def index
    @sensors = Sensor.all
  end

  def new

  end
  def create
    uid = "#{current_user.login}-#{params[:sensor][:name]}"
    @sensor =current_user.sensor.new(:description => params[:sensor][:description], :public => params[:sensor][:public], :uid => uid)
    if @sensor.save
      flash[:notice] = "Sensor Created Successfully"
      redirect_to sensor_path(@sensor)
    else
      flash[:error] = "Error creating sensor"
      render :action => :new
    end
  end

  def show
    @sensor = Sensor.find(params[:id])
  end

  def sensocol_demo
        @uuid = Digest::SHA1.hexdigest "hi"
        @token = Digest::SHA1.hexdigest "world"
  end

  def test_data
    render :text=> {:x => [1331552445, 13315524333], :y=>[35, 50]}.to_json
  end
end
