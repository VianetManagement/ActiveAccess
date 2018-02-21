require "pp"
require "ipaddr"
require "set"
require "rack"

module ActiveAccess
  class Middleware
    WHITELISTED_IPS = Set.new

    def self.allow_ip!(addr)
      WHITELISTED_IPS << IPAddr.new(addr)
    end

    allow_ip! "127.0.0.0/8"
    allow_ip! "::1/128" rescue nil # windows ruby doesn't have ipv6 support


    def initialize(app, handler = nil)
      @app      = app
      @handler  = handler
    end

    def call(rack_request)
      if allow_ip?(rack_request)
        @app.call(rack_request)
      else
        @app.call(rack_request)
      end
    end

    private

    def allow_ip?(rack_request)
      pp "~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
      pp rack_request
      ActiveAccess.logger.info rack_request
      pp "~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
      request = Rack::Request.new(rack_request)
      pp request
      ActiveAccess.logger.info request
      pp "~~~~~~~~~~~~~~~~~~~~~~~~~~~~"

      return true unless request.ip and !request.ip.strip.empty?
      ip = IPAddr.new request.ip.split("%").first
      WHITELISTED_IPS.any? { |subnet| subnet.include? ip }
    end

  end
end
