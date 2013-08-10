worker_processes 4
timeout 30
preload_app true

before_fork do |server, worker|
  ActiveRecord::Base.connection.disconnect!
  sleep 1
end

after_fork do |server, worker|
  ActiveRecord::Base.establish_connection
end
