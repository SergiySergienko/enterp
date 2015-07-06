module Connection
  class MessageDispatcher
    include Celluloid
    include Celluloid::Notifications
    trap_exit :actor_died

    attr_accessor :avatar, :socket

    def initialize

    end

    def set_avatar_instance(avatar)
      @avatar = avatar
    end

    def set_socket(socket)
      @socket = socket
    end

    def dispatch_incoming_message(message_data)
      puts "Dispatching incoming message #{message_data.inspect}"
      mess_data = Connection::MessageParser.parse_message_data(message_data)
      case mess_data[:cmd]
        when 5 # change position received
          @avatar.async.dispatch_new_position(mess_data[:cmd_data])
        else
          puts "!! ERROR: Unknown data received #{mess_data.inspect}"
      end
      # puts "Parsed #{mess_data.inspect}"
      # publish('new_broad_message', authorise_msg(message_data))
    rescue => e
      puts "Error in MessageDispatcher #{e.message}"
      terminate
    end

    def dispatch_outgoing_message(message_data)

    end

    def sock_wite(data)
      @socket << data
    end

    def authorise_msg(msg)
      "#{@avatar.get_global_a_index}|#{msg}"
    end

    def actor_died(actor, reason)
      puts "Message dispatcher DIED!!"
      terminate
    end

  end
end