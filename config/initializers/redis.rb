require 'celluloid/redis'
$redis ||= Redis.new(:driver => :celluloid)