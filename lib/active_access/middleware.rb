# frozen_string_literal: true

require "ipaddr"
require "set"
require "rack"

module ActiveAccess
  class Middleware
    attr_accessor :whitelisted_ips

    def initialize(app, handler = {})
      @app             = app
      @handler         = handler
      @whitelisted_ips = Set.new
      refresh_whitelisted_ips
    end

    def allow_ip!(addr)
      @whitelisted_ips << IPAddr.new(addr)
    end

    def call(rack_request)
      if allow?(rack_request)
        @app.call(rack_request)
      else
        [404, { "Content-Type" => "text/html", "Content-Length" => config.message.length.to_s }, [config.message]]
      end
    end

    def allow?(rack_request)
      request = Rack::Request.new(rack_request)
      return true unless protected_domain?(request)

      if request.ip.present?
        ip_address = IPAddr.new(request.ip.split("%").first)
        @whitelisted_ips.any? { |subnet| subnet.include? ip_address }
      end
    end

    def protected_domain?(request)
      return false if config.protected_domains.blank?
      config.protected_domains.any? { |domain| request.host == domain }
    end

    private

    # A place to fetch a cached / a list of IP's
    def refresh_whitelisted_ips
      allow_ip! "127.0.0.0/8"
      allow_ip! "::1/128"
      config.allow_ips&.each { |ip| allow_ip!(ip) }
    rescue StandardError # windows ruby doesn't have ipv6 support
      nil
    end

    def config
      @config ||= ActiveAccess.config.merge(@handler)
    end
  end
end
