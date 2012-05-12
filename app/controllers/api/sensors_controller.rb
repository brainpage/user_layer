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
    render :json => {:columns => ["one", "two", "three"], :data => [{:ts => 1.hour.ago.to_i, :one => "hello", :two => "world"}, {:ts=>2.hour.ago.to_i, :one => "again", :three => "hahaha"}]}.to_json
  end
end
