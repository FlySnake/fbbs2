
RAILS_ROOT = File.expand_path("..", File.dirname(__FILE__))
PUMA_PID_FILE = 'tmp/pids/puma.pid'
PUMA_SOCKET = 'tmp/sockets/puma.sock'
RAILS_ENV = ENV['RAILS_ENV'] || 'production'

BIND_TO = RAILS_ENV == 'production' ? "unix://#{PUMA_SOCKET}" : "tcp://0.0.0.0:3000"

START_COMMAND = "bundle exec puma --bind #{BIND_TO} --pidfile #{PUMA_PID_FILE} -e #{RAILS_ENV} -t 8:1024"
STOP_COMMAND = "kill -9 `cat #{File.join(RAILS_ROOT, "#{PUMA_PID_FILE}")}`"
PROCESS_STDOUT_LOGFILE = File.join(RAILS_ROOT, 'log/puma_stdout.log')
PROCESS_STDERR_LOGFILE = File.join(RAILS_ROOT, 'log/puma_stderr.log')

puts "*** God watchdog config ***"
puts "RAILS_ROOT: #{RAILS_ROOT}"
puts "RAILS_ENV #{RAILS_ENV}"
puts "START_COMMAND: #{START_COMMAND}"
puts "STOP_COMMAND: #{STOP_COMMAND}"
puts "PROCESS_STDOUT_LOGFILE #{PROCESS_STDOUT_LOGFILE}"
puts "PROCESS_STDERR_LOGFILE #{PROCESS_STDERR_LOGFILE}"

God.watch do |w|
  w.name = 'fbbs2_puma'
  w.dir = "#{RAILS_ROOT}"
  w.start = START_COMMAND
  w.stop = STOP_COMMAND
  w.pid_file = File.join(RAILS_ROOT, "#{PUMA_PID_FILE}")
  w.log = PROCESS_STDOUT_LOGFILE
  w.err_log = PROCESS_STDERR_LOGFILE
  w.behavior(:clean_pid_file)
  w.keepalive
end