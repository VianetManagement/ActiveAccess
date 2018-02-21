# frozen_string_literal: true

require "spec_helper"

module ActiveAccess
  RSpec.describe Middleware do
    let(:app) { described_class.new(->(_env) { "PASSED" }) }

    describe "Allowing IP requests" do
      before { allow_any_instance_of(described_class).to receive(:protected_domain?).and_return(true) }

      context "Local IP Addresses (Default)" do
        it "Should initialize with local ip addresses added" do
          expect(app.whitelisted_ips.count).to eq(1).or(eq(2))
          expect(app.whitelisted_ips).to include(IPAddr.new("127.0.0.0/8"))
        end

        it "Allows passage of whitelisted submasked-local ips" do
          expect(app.call("REMOTE_ADDR" => "127.0.0.1")).to eq("PASSED")
          expect(app.call("REMOTE_ADDR" => "127.1.0.2")).to eq("PASSED")
          expect(app.call("REMOTE_ADDR" => "127.3.0.3")).to eq("PASSED")
        end

        # [404, {"Content-Type"=>"text/html", "Content-Length"=>"18"}, ["Resource Not Found"]]
        it "Disallows passage of unknown ips" do
          response = app.call("REMOTE_ADDR" => "1.2.3.4")
          expect(response[0]).to eq(404)
          expect(response[1]).to be_a(Hash).and(have_key("Content-Type"))
          expect(response[2]).to be_a(Array).and(include("Resource Not Found"))

          expect(app.call("REMOTE_ADDR" => "128.0.0.1").first).to eq(404)
        end
      end

      context "Newly added IP addresses" do
        before { ActiveAccess.config.merge!(allow_ips: ["192.168.1.0/8", "32.40.22.33"]) }

        it "Should allow ip's that were initialized to pass" do
          expect(app.call("REMOTE_ADDR" => "192.168.1.1")).to eq("PASSED")
          expect(app.call("REMOTE_ADDR" => "192.168.1.101")).to eq("PASSED")
          expect(app.call("REMOTE_ADDR" => "32.40.22.33")).to eq("PASSED")
        end

        it "Does not allow other ip's to access" do
          expect(app.call("REMOTE_ADDR" => "44.32.2.1").first).to eq(404)
        end
      end
    end

    describe "Protected Domains" do
      context "Requests with protected domains" do
        before { ActiveAccess.config.merge!(protected_domains: ["admin.localhost.com", "google.com"]) }

        it "Should allow requests with the correct IP to access the protected subdomain" do
          expect(app.call("REMOTE_ADDR" => "127.0.0.1", "HTTP_HOST" => "admin.localhost.com:3000")).to eq("PASSED")
          expect(app.call("REMOTE_ADDR" => "127.0.0.1", "HTTP_HOST" => "google.com")).to eq("PASSED")
        end

        it "Should disallow requests that do not match a allowed IP address" do
          expect(app.call("REMOTE_ADDR" => "44.32.2.1", "HTTP_HOST" => "admin.localhost.com:3000")).to_not eq("PASSED")
          expect(app.call("REMOTE_ADDR" => "44.32.2.1", "HTTP_HOST" => "google.com")).to_not eq("PASSED")
        end

        it "Should allow passage if the domain isn't apart of the protected list" do
          expect(app.call("REMOTE_ADDR" => "44.32.2.1", "HTTP_HOST" => "non.protected.com")).to eq("PASSED")
          expect(app.call("REMOTE_ADDR" => "44.32.2.1", "HTTP_HOST" => "localhost:3000")).to eq("PASSED")
        end
      end

      context "Requests without protected domains" do
        it "Should allow passage if the domain requested isn't protected" do
          expect(app.call("REMOTE_ADDR" => "44.32.2.1", "HTTP_HOST" => "non.protected.com")).to eq("PASSED")
        end
      end
    end
  end
end
