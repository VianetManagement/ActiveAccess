# frozen_string_literal: true

require "ipaddr"
require "set"
require "rack"

module ActiveAccess
  class Middleware
    WHITELISTED_IPS = Set.new

    def self.allow_ip!(addr)
      WHITELISTED_IPS << IPAddr.new(addr)
    end

    def initialize(app, handler = {})
      @app             = app
      @handler         = handler
      refresh_whitelisted_ips
    end

    def call(rack_request)
      if allow?(rack_request)
        @app.call(rack_request)
      else
        [404, { "Content-Type" => "text/html", "Content-Length" => config.message.length.to_s }, [config.message]]
      end
    end

    private

    def allow?(rack_request)
      request = Rack::Request.new(rack_request)
      return true unless protected_domain?(request)

      if request.ip.present?
        ip_address = IPAddr.new(request.ip.split("%").first)
        WHITELISTED_IPS.any? { |subnet| subnet.include? ip_address }
      end
    end

    def protected_domain?(request)
      return false if config.protected_domains.blank?
      config.protected_domains[request.host].presence
    end

    # A place to fetch a cached / a list of IP's
    def refresh_whitelisted_ips
      config.allowed_ips.merge(["127.0.0.0/8", "::1/128"])
      config.allowed_ips&.each do |ip|
        begin
          ActiveAccess::Middleware.allow_ip!(ip)
        ensure
          next # windows ruby doesn't have ipv6 support
        end
      end
    end

    def config
      @config ||= ActiveAccess.config.merge(@handler)
    end
  end
end
