module Connection
  class MessageParser

    def self.parse_message_data(data)
      result = {}
      cmd, cmd_data = data.split(":")
      result[:cmd] = cmd.to_i
      result[:cmd_data] = cmd_data.split(",")
      result
    end

    def self.parse_private_message_data(message)
      result = {}
      aid, other_data = message.split("|")
      cmd, cmd_data = other_data.split(":")
      result[:aid] = aid.to_i
      result[:cmd] = cmd.to_i
      result[:cmd_data] = cmd_data
      result
    end

  end
end