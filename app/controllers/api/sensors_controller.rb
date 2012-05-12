class Api::SensorsController < ApplicationController
  layout "api"
  before_filter :authenticate_user!
  
  def index
    @sensors = current_user.sensors
  end
  
  def data
    @sensor = current_user.sensors.find_by_uuid(params[:id])
  end

  def test_data
    render :json => Feature.all.to_json
  end
end
