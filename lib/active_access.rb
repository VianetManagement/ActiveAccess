# frozen_string_literal: true

require "pp"
require "active_access/middleware"
require "active_access/version"


module ActiveAccess

  class << self
    attr_accessor :application_root, :logger
  end

end

require "active_access/rails" if defined? Rails::Railtie
