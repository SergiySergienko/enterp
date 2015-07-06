require File.expand_path('../avatar_session_group', __FILE__)
require File.expand_path('../connection/broadcast_receiver', __FILE__)
require File.expand_path('../connection/message_dispatcher', __FILE__)
require File.expand_path('../connection/private_message_receiver', __FILE__)

class ActiveConnection
  attr_accessor :socket, :supervision_group, :connection_id, :is_alive

  def initialize(websocket)
    @socket = websocket
    @connection_id = Time.now.to_i
    @is_alive = true
  end

  def close_socket
    @socket.close
  end

  def get_connection_id
    @connection_id
  end

  def is_alive?
    @is_alive
  end

  def mark_as_dead!
    @is_alive = false
  end

  def proceed_connection!
    # @supervision_group = AvatarSessionGroup.run!
    #
    # avatar = @supervision_group[:p_avatar]
    # p_listener = @supervision_group[:pending_listener]

    p_listener = Connection::CheckPendingListener.new
    b_receiver = Connection::BroadcastReceiver.new(@socket)
    message_dispatcher = Connection::MessageDispatcher.new
    avatar = Avatar.new
    p_mess_listener = Connection::PrivateMessageReceiver.new(@socket, avatar)

    message_dispatcher.set_avatar_instance(avatar)

    p_listener.set_avatar_id(avatar.get_global_a_index)
    p_listener.set_message_dispatcher(message_dispatcher)
    p_listener.set_avatar_instance(avatar)
    p_listener.start_listening(@socket)

    avatar.set_current_socket(@socket)
    avatar.set_connection(self)

    avatar.set_p_listener(p_listener)
    avatar.link p_listener
    message_dispatcher.link p_listener
    p_listener.link avatar
    p_listener.link message_dispatcher
    b_receiver.link p_listener
    p_mess_listener.link avatar

    Celluloid::Actor[:gws_holder].async.add_avatar(avatar)

    self
  end

end