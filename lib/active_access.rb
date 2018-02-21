# frozen_string_literal: true

require "active_support/core_ext/object/blank"

require "active_access/config"
require "active_access/middleware"
require "active_access/version"

module ActiveAccess
  class << self
    attr_accessor :application_root, :logger

    def config
      @config ||= Config.new
    end
  end
end

require "active_access/rails" if defined? Rails::Railtie
