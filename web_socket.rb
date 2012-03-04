require 'em-websocket'

EventMachine::WebSocket.start(:host => "192.168.96.175", :port => 8080) do |ws|
  ws.onopen    { puts 'connected'; ws.send "Hello Client!"}
  ws.onmessage { |msg| puts msg; ws.send "Pong: #{msg}" }
  ws.onclose   { puts "WebSocket closed" }
end
