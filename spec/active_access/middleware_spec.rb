# frozen_string_literal: true

require "spec_helper"

module ActiveAccess
  RSpec.describe Middleware do
    let(:app) { described_class.new(->(_env) { "PASSED" }) }

    describe "Allowing IP requests" do
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
  end
end
