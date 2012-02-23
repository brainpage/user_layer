class Geocoder < FaradayBase
  def self.encode(location)
    re = self.conn('http://maps.googleapis.com').get("/maps/api/geocode/json?address=#{location}&sensor=false")
    #Parse into an new hahs of lat, long and name
    return re.body["results"].map{|addr| {:description=>addr["address_components"].select{|ac| ac["types"][1] == "political"}.map{|ac| ac["short_name"]}.uniq.join(", "), :lat=>addr["geometry"]["location"]["lat"], :lng=>addr["geometry"]["location"]["lng"]}}
                            
  end
end
   #connection.post("/sensors/#{type}/#{id}", {"app_id" => app_id, "app_url" => app_url})
