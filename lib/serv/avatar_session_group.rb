require File.expand_path('../avatar', __FILE__)
require File.expand_path('../connection/check_pending_listener', __FILE__)

class AvatarSessionGroup < Celluloid::SupervisionGroup
  trap_exit :kill_group

  supervise Connection::CheckPendingListener, as: :pending_listener
  supervise Avatar, as: :p_avatar

  def kill_group(actor, reason)
    puts "Killing group !!!!!!!!!!!!!!"
  end

end
