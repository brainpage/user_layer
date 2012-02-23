class SensorsController < ApplicationController
  def index
    @sensors = Sensor.all
  end
end
