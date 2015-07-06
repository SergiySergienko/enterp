# Global 'system_tick' timer
class SystemTickServer
  include Celluloid
  include Celluloid::Notifications

  def initialize
    # subscribe('system_tick', :new_message)
    async.run
  end

  def run
    now = Time.now.to_f
    sleep now.ceil - now + 0.001
    every(0.5) do
      publish 'system_tick'
    end
  end

  # def new_message(topic)
  #   puts "@"*50
  #   Celluloid.stack_dump
  # end

end