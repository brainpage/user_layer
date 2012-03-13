require 'em-websocket'

EventMachine::WebSocket.start(:host => "192.168.96.175", :port => 8080) do |ws|
  ws.onopen    { puts 'connected'; ws.send('{"action":"connack", "status":"ok"}'); ws.send('{"action":"command", "command":"rsi_alert","rest_time":"15","warn_time":"5"}')}
  ws.onmessage { |msg| puts msg;  }
  ws.onclose   { puts "WebSocket closed" }
end
