require 'em-websocket'
require File.expand_path("../config/environment", __FILE__)

EventMachine::WebSocket.start(:host => "192.168.96.175", :port => 8080) do |ws|
  ws.onopen { puts 'connected'; ws.send('{"action":"connack", "status":"ok"}'); }
  ws.onmessage { |msg|
    puts msg;
    msg = YAML.load(msg)
    if msg["action"] == "event_batch"
      msg["events"].each do |t|
        ClientEvent.build(t)
      end
    else
      ClientEvent.build(msg)
    end
  }
  ws.onclose   { puts "WebSocket closed" }
end
