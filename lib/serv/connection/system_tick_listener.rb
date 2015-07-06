module Connection
  class SystemTickListener
    include Celluloid
    include Celluloid::Notifications
    trap_exit :actor_died

    attr_accessor :gws_holder

    def initialize
      @gws_holder = Actor[:gws_holder]
      subscribe('system_tick', :sys_tick)
    end

    def sys_tick(topic)
      avatars = @gws_holder.get_avatars
      result = "999|99:"
      if avatars.length > 0
        avatars.each do |key, val|
          tmp_data = "#{val.get_global_a_index}:#{val.get_x},#{val.get_y},#{val.get_a}."
          result += tmp_data
        end
        publish('new_broad_message', result)
      end
    end

    def actor_died(actor, reason)
      terminate
    end

  end
end