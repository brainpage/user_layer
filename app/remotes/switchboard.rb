class Switchboard < FaradayBase
  def self.create_sensor(type, id)
    re = self.conn('http://localhost:4000').post("/sensors/#{type}/#{id}")
  end
  def self.update_settings_for(sensor_type, uuid)
    re = self.conn('http://switchboard:8080').get("/internal/#{sensor_type}/#{uuid}/update_settings")
  end
  
end
