# frozen_string_literal: true

require "active-access/utility/hash_mapper"

module ActiveAccess
  module Utility
    class Config < HashMapper
      def initialize(*)
        super

        domains                   = protected_domains
        good_urls                 = whitelisted_urls
        self["protected_domains"] = {}
        self["whitelisted_urls"]  = {}

        self.whitelisted_urls  = good_urls
        self.protected_domains = domains
        self.allowed_ips       = allowed_ips
        self.enabled           = true if enabled.nil?
        self.message           = "Resource Not Found" if message.nil?
      end

      def allowed_ips=(ip_addresses)
        self["allowed_ips"] = Set.new(split_or_ship(ip_addresses))
      end

      def protected_domains=(domains)
        return if domains.blank?
        split_or_ship(domains).each { |domain| self["protected_domains"][strip_url(domain)] = true }
      end

      def whitelisted_urls=(url_sets)
        return if url_sets.blank?
        split_or_ship(url_sets).each do |url_set|
          url, request_method = url_set
          next if url.blank?
          self["whitelisted_urls"][strip_url(url)] = request_method.nil? ? "GET" : request_method.to_s.upcase
        end
      end

      def strip_url(url)
        url.to_s.sub(%r{^https?\:\/\/(www.)?}, "")
      end

      private

      def split_or_ship(values)
        values.is_a?(String) ? values.split(",").map(&:strip) : values
      end
    end
  end
end
