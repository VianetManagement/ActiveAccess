
# frozen_string_literal: true

require "spec_helper"

module ActiveAccess
  RSpec.describe Config do
    let(:config) { described_class.new }

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
end
