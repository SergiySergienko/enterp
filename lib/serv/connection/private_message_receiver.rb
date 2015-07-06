module Connection
  class PrivateMessageReceiver
    include Celluloid
    include Celluloid::Notifications

    trap_exit :actor_died

    def initialize(websocket, avatar)
      @socket = websocket
      @avatar = avatar
      subscribe('new_private_message', :receive_private_message)
    end

    def receive_private_message(topic, message)
      mess_data = Connection::MessageParser.parse_private_message_data(message)
      if mess_data[:aid] == @avatar.get_global_a_index
        @socket << message
      end
    rescue Reel::SocketError, EOFError, IOError
      puts "PRIVATE Messager disconnected"
      terminate
    end

    def actor_died(actor, reason)
      terminate
    end

  end
end