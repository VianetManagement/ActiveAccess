# frozen_string_literal: true

require "active_support/core_ext/object/blank"

require "active-access/utility/config"
require "active-access/middleware"
require "active-access/version"

module ActiveAccess
  class << self
    attr_accessor :application_root, :logger

    def config
      @config ||= Utility::Config.new
    end

    def configure
      yield config
    end
  end
end

require "active-access/rails" if defined? Rails::Railtie
