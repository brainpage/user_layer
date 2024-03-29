require 'em-websocket'
require File.expand_path("../config/environment", __FILE__)

EventMachine.run {

    EventMachine::WebSocket.start(:host => "192.168.1.4", :port => 8080) do |ws|
        ws.onopen {
          puts "WebSocket connection open"
          puts (ws.request).inspect
          # publish message to the client
          ws.send "Hello Client"
        }

        ws.onclose { puts "Connection closed" }
        ws.onmessage { |msg|
          puts msg.unpack('H*').to_a.inspect
          
          if @h.blank?
            ws.send({:action => "schema_request", :schema_hash => msg.unpack('H*')[0][0, 32]}.to_json)
            @h = 2
          end
        
        }
    end
}
