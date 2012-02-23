# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$(document).ready ->
    $("#new_weather_location").bind "ajax:success", (event, data) ->
      $("#choose_location").html(data)
    .bind "ajax:error", (event, data) ->
      alert("Error Finding Location")
