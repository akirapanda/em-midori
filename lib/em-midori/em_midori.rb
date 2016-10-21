require 'logger'

module Midori
  @logger = ::Logger.new(STDOUT)
  # Start Midori Server instance
  # === Attributes
  # * +api+ [+Class+] - Inherit from +Midori::API+
  # * +ip+ [+String+] - The ip address to bind, default: 127.0.0.1
  # * +port+ [+Fixnum+] - Port number, default: 8081
  # * +logger+ [+Logger+] - Ruby logger, default: ::Loger.new(STDOUT) 
  def self.run(api = Midori::API, ip = nil, port = nil, logger = ::Logger.new(STDOUT))
    ip ||= '127.0.0.1'
    port ||= 8081
    @logger = logger
    EventMachine.run do
      @logger.info "Midori #{Midori::VERSION} is now running on #{ip}:#{port}".blue
      @midori_server = EventMachine.start_server ip, port, Midori::Server, api, logger
    end
  end

  def self.stop
    if @midori_server.nil?
      @logger.error 'Midori Server has NOT been started'.red
      return false
    else
      EventMachine.stop_server(@midori_server)
      @midori_server = nil
      @logger.info 'Goodbye Midori'.blue
      return true
    end
  end
end
