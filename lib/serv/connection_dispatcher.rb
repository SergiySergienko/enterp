#
# New incomming websocket connection handler
# Starts new client enviroment
# Send event to register in in Global World State
# Starts sockets listeners/writers
#
require File.expand_path('../active_connection', __FILE__)

class ConnectionDispatcher
  include Celluloid

  finalizer :avatar_died
  trap_exit :actor_died

  def initialize
    puts "INIT Dispatcher"
  end

  def handle_new_connection(websocket)
    puts "Handle new connection called!!!!!"

    conn = ActiveConnection.new(websocket)
    conn = conn.proceed_connection!
    Actor[:c_manager].add_active_connection(conn)

    return
  end

  def actor_died(actor, reason)
    puts "Oh no! #{actor.inspect} has died because of a #{reason.class}"
    terminate
  end

  def avatar_died
    puts "DISPATCHER DIEd !!"
  end

end