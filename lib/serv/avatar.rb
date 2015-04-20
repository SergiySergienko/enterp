# Client avatar (system state and connection socket) holder
class Avatar
  include Celluloid
  include Celluloid::Notifications

  finalizer :avatar_died
  trap_exit :actor_died

  attr_accessor :current_socket, :p_listener, :global_a_index, :connection_instance

  def initialize
    indx = Actor[:c_manager].future.get_current_connections_count
    set_global_a_index(indx.value)
  end

  def set_global_a_index(a_index)
    puts "Avatar: MY INDEX IS #{a_index}"
    @global_a_index = a_index
  end

  def set_connection(connection_instance)
    @connection_instance = connection_instance
  end

  def get_global_a_index
    @global_a_index
  end

  def set_current_socket(socket)
    @current_socket = socket
  end

  def get_current_socket
    @current_socket
  end

  def set_p_listener(p_listener)
    @p_listener = p_listener
  end

  def get_p_listener
    @p_listener
  end


  def actor_died(actor, reason)
    puts "Oh no! #{actor.inspect} has died because of a #{reason.class}"
    publish('active_connection_died', @connection_instance)
    terminate
  end

  def avatar_died
    puts "Avatar DIEd !!: #{get_global_a_index}"
  end


end