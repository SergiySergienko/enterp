#
# Global World State Holder
# Hold all active players (links to avatars objects)
# Accepts/answers to new players registration/delete old events
#
class GwsHolder
  include Celluloid
  include Celluloid::Notifications

  attr_accessor :avatars, :current_a_index

  def initialize
    @avatars = {}
    @current_a_index = 0
    async.run_dead_check
  end

  def get_avatars
    @avatars
  end

  def get_a_index
    @current_a_index
  end

  def inc_a_index
    # exclusive do
      @current_a_index += 1
    # end
  end

  def dec_a_index
    # exclusive do
      @current_a_index -= 1
    # end
  end

  def add_avatar(avatar)
    # exclusive do
      puts "Register new avatar in global space : #{avatar.get_global_a_index}"
      key = "#{avatar.get_global_a_index}"
      # avatar.async.set_global_a_index(@current_a_index)
      @avatars[key] = avatar

      publish('new_private_message', authorise_msg(avatar, "0:#{key}"))
      # registered_avatar_keys = @avatars.values.map(&:get_global_a_index).join(",")
      # publish('new_broad_message', "999|91:#{registered_avatar_keys}")
    # end
  end

  def remove_avatar(a_index)
    # exclusive do
      key = "#{a_index}"
      puts "Remove avatar from global space : #{a_index} / #{@avatars.size} #{@avatars.has_key?(key)}"

      @avatars.delete(key)



    # end
  end

  def run_dead_check
    now = Time.now.to_f
    sleep now.ceil - now + 0.001
    every(0.5) do
      check_for_dead
    end
  end

  private

  def authorise_msg(avatar, msg)
    "#{avatar.get_global_a_index}|#{msg}"
  end

  def check_for_dead
    @avatars.each do |key, c_actor|
      remove_avatar(key) unless c_actor.alive?
    end
  end

end