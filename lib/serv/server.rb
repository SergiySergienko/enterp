#
# Main server
# handle incoming connections and creates new avatars
#
require 'rubygems'
require 'bundler/setup'
require 'celluloid'
require 'reel'
require 'celluloid/autostart'

require File.expand_path('../connection_dispatcher', __FILE__)
require File.expand_path('../gws_holder', __FILE__)
require File.expand_path('../system_tick_server', __FILE__)
require File.expand_path('../connections_manager', __FILE__)
require File.expand_path('../connection/system_tick_listener', __FILE__)
require File.expand_path('../connection/message_parser', __FILE__)

class Server < Reel::Server::HTTP
  include Celluloid::Logger
  finalizer :shutdown

  def initialize(host = "127.0.0.1", port = 1234)
    info "Server starts on #{host}:#{port}"
    # GC::Profiler.enable
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
    if Actor[:c_manager].get_current_connections_count < ConnectionsManager::MAX_ACTIVE_CONNECTIONS_COUNT
      if socket.url == "/ws"
        Actor[:c_manager].async.add_to_pending(socket)
        return
      else
        info "Non supported URL #{socket.url}"
        socket.close
      end
    else
      info "Too much connections"
      socket.close
    end
  end

  def shutdown
    # GC::Profiler.report
    # GC::Profiler.disable
    super
  end

end

class ServerGroup < Celluloid::SupervisionGroup
  supervise SystemTickServer, as: :s_timer
  supervise Server, as: :reel
  supervise GwsHolder, as: :gws_holder
  supervise ConnectionsManager, as: :c_manager
  supervise Connection::SystemTickListener, as: :s_t_listener
  pool ConnectionDispatcher, as: :conn_dispatcher, size: ConnectionsManager::FETCH_BATCH_SIZE

end

ServerGroup.run!

sleep