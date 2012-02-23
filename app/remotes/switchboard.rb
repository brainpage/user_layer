class Switchboard < FaradayBase
  def self.create_sensor(type, id)
    re = self.conn('http://localhost:4000').post("/sensors/#{type}/#{id}")
  end

  
end
