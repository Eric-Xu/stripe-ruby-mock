module StripeMock

  @default_pid_path = './stripe-mock-server.pid'

  def self.default_server_pid_path; @default_pid_path; end
  def self.default_server_pid_path=(new_path)
    @default_pid_path = new_path
  end


  def self.spawn_server(opts={})
    pid_path = opts[:pid_path] || @default_pid_path

    if File.exists?(pid_path)
      puts "StripeMock Server already running [#{pid_path}]"
    else
      Dante::Runner.new('stripe-mock-server').execute(:daemonize => true, :pid_path => pid_path) {
        StripeMock::Server.start_new(opts)
      }
      at_exit { kill_server(pid_path) }
    end
  end

  def self.kill_server(pid_path=nil)
    path = pid_path || @default_pid_path
    Dante::Runner.new('stripe-mock-server').execute(:kill => true, :pid_path => path)
  end

end
