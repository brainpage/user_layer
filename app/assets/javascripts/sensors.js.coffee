# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
connect= ()->
    host = "ws://localhost:8080/sensocol"

    socket = new WebSocket(host)

    message('<p class="event">Socket State: ' + socket.readyState)

    socket.onopen = (evt)->
        msg = {action: "connect", sensor: {uuid:$("#sensor_uuid").val(), token:$("#sensor_token").val()}}
        socket.send(JSON.stringify(msg))
        message('<p class="event">Socket State: ' + socket.readyState + ' (open)')
        message('<p class="msg">Sent:' + JSON.stringify(msg))

    socket.onmessage = (evt) ->
        message('<p class="msg"> Rec:' + evt.data)
message = (msg) ->
    $('#chatLog').append(msg + "</p")


$(document).ready ->
    $("#connect").bind('click', (event) ->
        connect()
    )
