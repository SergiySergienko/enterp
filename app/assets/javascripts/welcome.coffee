# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
#SocketKlass = "MozWebSocket" in window ? MozWebSocket : WebSocket
current_player_id = "client1"
@ws = new WebSocket('ws://localhost:1234/timeinfo')
@ws.onmessage = (msg) ->
  document.getElementById('current-time').innerHTML = msg.data
  parse_inc_mess(msg.data)

@ws.on_open = () ->
  @ws.send("asdasdasd asd")

