module Connection
  class CheckPendingListener
    include Celluloid
    include Celluloid::Logger
    include Celluloid::Notifications

    attr_accessor :socket, :check_timer, :a_id
    trap_exit :actor_died

    def set_avatar_id(aid)
      @a_id = aid
    end

    def start_listening(websocket)
      @socket = websocket
      async.start_reading
    end

    def start_reading
      # now = Time.now.to_f
      # sleep now.ceil - now + 0.001
      @check_timer = every(0.01) do
        read_from_sock
      end
    end

    def read_from_sock
      msg = @socket.read
      puts "New message from socket #{msg.inspect}"
      publish('new_broad_message', authorise_msg(msg))
      return
    rescue Reel::SocketError, EOFError, IOError, Errno::ECONNRESET
      info "Reader WS client disconnected"
      stop_timer!
      terminate
    end

    def authorise_msg(msg)
      "#{@a_id}|#{msg}"
    end

    def stop_timer!
      @check_timer.cancel if @check_timer
    end

    def actor_died(actor, reason)
      stop_timer!
      terminate
    end

  end
end