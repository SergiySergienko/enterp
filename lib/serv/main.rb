require "rubygems"
require 'bundler/setup'
require "celluloid"
require "reel"
require "celluloid/autostart"

class GlobalWorldState
  include Celluloid
  include Celluloid::Notifications
  include Celluloid::Logger

  attr_accessor :players

  def initialize
    @players = {}
  end

  def add_player(avatar_object)
    info "new avatar called #{avatar_object.inspect}"
    a_id = avatar_object.get_aid
    @players[a_id.to_s] = avatar_object
    info "Player added, all players are #{@players.inspect}"

  end

  def del_player(aid)
    @players.delete(aid)
  end

  def get_players
    @players
  end

  def new_avatar(avatar_object)
    async.add_player(avatar_object)
  rescue => e
    info "Error in WGS #{e.message}"
    terminate
  end

  def del_avatar(aid)
    async.del_player(aid)
  rescue => e
    info "Error in WGS #{e.message}"
    terminate
  end

end

class AvatarBase

  attr_accessor :aid, :svisor

  def get_aid
    @aid
  end

  def set_aid(aid)
    @aid = aid
  end

  def register_as(aid, svisor)
    @svisor = svisor
    @aid = aid
  end

end

class PlayerAvatar < AvatarBase
  include Celluloid
  include Celluloid::Logger
  include Celluloid::Notifications
  attr_reader :pos_x, :pos_y, :angle, :g_world_state

  def initialize
    @pos_x = 0
    @pos_y = 0
    @angle = 0
    @g_world_state = Actor[:g_w_s]
  end

  def register_as(aid, svisor)
    super
    @g_world_state.async.new_avatar(self)
  end

  def set_avatar_id(id)
    @id = id
  end

  def do_some
    puts "@"*14
    puts @id.inspect
    @id
  end

end

class NonBlockingSockManager
  include Celluloid
  include Celluloid::Notifications

  def initialize
    async.run
  end

  def run
    now = Time.now.to_f
    sleep now.ceil - now + 0.001
    every(0.01) do
      publish 'check_for_messages'
    end
  end
end

class SockReader < AvatarBase
  include Celluloid
  include Celluloid::Notifications
  include Celluloid::Logger

  attr_accessor :g_world_state

  finalizer :reader_died

  def initialize
    @g_world_state = Actor[:g_w_s]
  end

  def do_start(websocket)
    info "Reading from socket"
    @socket = websocket
    subscribe('check_for_messages', :new_message)
  end

  def new_message(topic)
    msg = @socket.read
    publish 'new_ws_message', msg
  rescue Reel::SocketError, EOFError, IOError
    info "Reader WS client disconnected"
    terminate
  end

  def reader_died
    @g_world_state.async.del_avatar(@aid)
  end

end

class SockWriter < AvatarBase
  include Celluloid
  include Celluloid::Notifications
  include Celluloid::Logger

  attr_accessor :g_world_state

  def initialize
    @g_world_state = Actor[:g_w_s]
  end

  def do_start(websocket)
    info "Writing back to socket"
    @socket = websocket
    subscribe('new_ws_message', :new_message)
  end

  def new_message(topic, data)
    info("MESSAGE DATA : #{data.inspect}")
    command, aid, x, y, angle = data.split(",")
    if command.to_s == "1"
      @socket << data
    else
      info "Unknown command receiver !! #{data.inspect}"
    end
    # @socket << data
  rescue Reel::SocketError, EOFError, IOError
    info "Writer WS client disconnected"
    terminate
  end

end

class AvatarGroup < Celluloid::SupervisionGroup
  supervise SockReader, as: :s_reader
  supervise SockWriter, as: :s_writer
  supervise PlayerAvatar, as: :p_avatar

end

class ClientGroup
  include Celluloid

  attr_accessor :sock_writer, :sock_reader, :p_avatar

  def initialize(sock_writer, sock_reader, p_avatar)
    @sock_writer = sock_writer
    @sock_reader = sock_reader
    @p_avatar = p_avatar
  end

end

class MainServer < Reel::Server::HTTP
  include Celluloid::Logger

  def initialize(host = "127.0.0.1", port = 1234)
    info "Server starts on #{host}:#{port}"
    super(host, port, &method(:on_connection))
  end

  def on_connection(connection)
    while request = connection.request
      if request.websocket?
        info "Received a WebSocket connection"
        connection.detach

        route_ws_request request.websocket
        return
      else
        info "Received a non supported connection"
      end
    end
  end

  def route_ws_request(socket)
    if socket.url == "/ws"
      supervisor = AvatarGroup.run!

      aid = Time.now.to_i.to_s

      supervisor[:p_avatar].register_as(aid, supervisor)
      supervisor[:s_reader].register_as(aid, supervisor)
      supervisor[:s_writer].register_as(aid, supervisor)

      supervisor[:s_reader].async.do_start(socket)
      supervisor[:s_writer].async.do_start(socket)

    else
      info "Non supported URL #{socket.url}"
      socket.close
    end
  end

end

GlobalWorldState.supervise_as :g_w_s
NonBlockingSockManager.supervise_as :periodic_reader
MainServer.supervise_as :reel

sleep