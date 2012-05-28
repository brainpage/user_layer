require "em-ws-client"

EM.run do

  # Establish the connection
  ws = EM::WebSocketClient.new("ws://127.0.0.1:8080")

puts ws

  # Simple echo
  # If the binary flag is set, then
  # the message is a string encoded as ASCII_8BIT
  # otherwise it's encoded as UTF-8
  ws.onmessage do |msg, binary|
   # ws.send_message msg, binary
  end
  
  ws.onopen do
      puts "onopen"
      ws.send_message "hello"
    end

    ws.onclose do |code, explain|
      puts explain
    end

    ws.onping do |msg|
      puts "ping: #{msg}"
    end

    ws.onerror do |code, message|
      puts "error: #{message}"
    end

   

    ws.onpong do |msg|
      puts "pong: #{msg}"
    end

  # Send a binary message
 # ws.send_message [2,3,4].pack("NnC"), true

end