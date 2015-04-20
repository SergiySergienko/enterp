module Engine
  module SystemState
    class Collector

      attr_accessor :user_id, :player_id, :session_id, :pos_x, :pos_y, :angle

      def initialize(player_id)
        @player_id = player_id
      end

      def collect_data
        JSON.parse($redis.get(r_key_name))
      end

      def update_data(data)
        $redis.set r_key_name, data.to_json
      end

      private

      def r_key_name
        "#{@player_id}_data"
      end

    end
  end
end