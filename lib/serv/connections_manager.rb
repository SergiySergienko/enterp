#
# This class manage all incoming connections,
# ping are and kill if necessary
#
class ConnectionsManager
  include Celluloid
  include Celluloid::Notifications

  MAX_ACTIVE_CONNECTIONS_COUNT = 200
  FETCH_BATCH_SIZE = 2

  attr_accessor :active_connections, :pending_connections, :current_connections_count

  def initialize
    @active_connections = []
    @pending_connections = []
    @current_connections_count = 0
    subscribe('active_connection_died', :remove_from_active)
    async.run_pending_check
  end

  def get_current_connections_count
    @active_connections.size
  end

  def add_to_pending(socket)
    puts "Add conn to pending"
    @pending_connections << socket
  end

  def add_active_connection(connection)
    puts "Add active connection #{connection.connection_id}"
    @active_connections << connection
  end

  def remove_from_pending(socket)
    puts "REMOVE connection pending"
    @pending_connections.delete(socket)
  end

  def remove_from_active(topic, connection)
    puts "REMOVE connection active #{connection.connection_id}"
    connection.close_socket
    @active_connections.delete(connection)
    connection = nil
  end

  def get_next_pendings(n=1)
    return [] unless @pending_connections.length > 0
    @pending_connections.shift(n)
  end

  def run_pending_check
    now = Time.now.to_f
    sleep now.ceil - now + 0.001
    every(1) do
      proceed_next_batch
    end
  end

  def proceed_next_batch
    c_batch = get_next_pendings(FETCH_BATCH_SIZE)
    # puts "PROCEED PENDING #{c_batch.size.inspect}"
    if c_batch.length > 0
      if !((get_current_connections_count + c_batch.length) > MAX_ACTIVE_CONNECTIONS_COUNT)
        c_batch.each do |socket|
          Actor[:conn_dispatcher].async.handle_new_connection(socket)
        end
      end
    end
  end

end