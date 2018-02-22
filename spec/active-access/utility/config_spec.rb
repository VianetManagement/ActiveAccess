
# frozen_string_literal: true

require "spec_helper"

module ActiveAccess
  module Utility
    RSpec.describe Config do
      let(:config) { described_class.new }

      describe "Config Hash Mapper Functionality" do
        it "Should initialize by default with enabled setting and error message" do
          expect(config.enabled).to eq(true)
          expect(config.message).to eq("Resource Not Found")
        end

        it "Should allow for assigning values using the chain method" do
          expect(config.test_key?).to eq(false)
          expect(config.test_key).to eq(nil)

          config.test_key = "PASSED"
          expect(config.test_key).to eq("PASSED")
          expect(config.test_key?).to eq(true)
        end

        it "Should allow someone to perform a simple merge" do
          config.merge!(error: false, success: true)
          expect(config.error).to eq(false)
          expect(config.success).to eq(true)
        end

        it "Should allow me to initialize with new values" do
          new_config = described_class.new(enabled: false, success: "TRUE")
          expect(new_config.enabled).to eq(false)
          expect(new_config.success).to eq("TRUE")
        end
      end

      describe "#allowed_ips" do
        let(:ip_addresses) { ["127.0.0.1", "192.168.1.1"] }

        it "Will accept a comma delimited string for allowed ips" do
          config.allowed_ips = ip_addresses.join(", ")
          contains_permitted_ips(config)
        end

        it "Should allow me to initialise with an Array of ip addresses" do
          new_config = described_class.new(allowed_ips: ip_addresses)
          contains_permitted_ips(new_config)
        end

        it "Should convert all array assigned domains into a Set Map" do
          config.allowed_ips = ip_addresses
          contains_permitted_ips(config)
        end

        def contains_permitted_ips(config) # rubocop:disable Metrics/AbcSize
          expect(config.allowed_ips).to be_a(Set)
          expect(config.allowed_ips).to include(ip_addresses.first)
          expect(config.allowed_ips).to include(ip_addresses.last)
        end
      end

      describe "#protected_domains" do
        let(:domains) { ["localhost", "admin.localhost.com"] }

        it "Will accept a comma delimited string for protected domains" do
          config.protected_domains = domains.join(", ")
          contains_protected_domains(config)
        end

        it "Should allow me to initialise with an Array of domains" do
          new_config = described_class.new(protected_domains: domains)
          contains_protected_domains(new_config)
        end

        it "Should convert all array assigned domains into a Hash Map" do
          config.protected_domains = domains
          contains_protected_domains(config)
        end

        def contains_protected_domains(config)
          expect(config.protected_domains).to be_a(Hash)
          expect(config.protected_domains).to have_key("localhost")
          expect(config.protected_domains).to have_key("admin.localhost.com")
        end
      end
    end
  end
end
