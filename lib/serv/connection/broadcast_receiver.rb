module Connection
  class BroadcastReceiver
    include Celluloid
    include Celluloid::Notifications

    trap_exit :actor_died

    def initialize(websocket)
      @socket = websocket
      subscribe('new_broad_message', :receive_broad_message)
    end

    def receive_broad_message(topic, message)
      @socket << message
    rescue Reel::SocketError, EOFError, IOError
      puts "BROADCASTER client disconnected"
      terminate
    end

    def actor_died(actor, reason)
      terminate
    end

  end
end