# frozen_string_literal: true

require "active_access/utility/hash_mapper"

module ActiveAccess
  module Utility
    class Config < HashMapper
      def initialize(*)
        super

        if protected_domains.nil?
          self["protected_domains"] = {}
        elsif protected_domains.is_a?(Array)
          domains = protected_domains
          self["protected_domains"] = {}
          self.protected_domains    = domains
        end

        self.allowed_ips = allowed_ips
        self.enabled     = true if enabled.nil?
        self.message     = "Resource Not Found" if message.nil?
      end

      def allowed_ips=(ip_addresses)
        ip_addresses = split_or_ship(ip_addresses)
        self["allowed_ips"] = Set.new(split_or_ship(ip_addresses))
      end

      def protected_domains=(domains)
        return if domains.blank?
        split_or_ship(domains).each { |domain| self["protected_domains"][domain.to_s] = true }
      end

      private

      def split_or_ship(values)
        values.is_a?(String) ? values.split(",").map(&:strip) : values
      end
    end
  end
end
