# frozen_string_literal: true

module ActiveAccess
  class Railtie < Rails::Railtie

    config.after_initialize do
      initialize_active_access
    end

    def initialize_active_access
      if use_active_access?
        insert_middleware
        ActiveAccess.logger           = Rails.logger
        ActiveAccess.application_root = Rails.root.to_s
      end
    end

    def insert_middleware
      if defined? ActionDispatch::DebugExceptions
        app.middleware.insert_after ActionDispatch::DebugExceptions, ActiveAccess::Middleware
      else
        app.middleware.use ActiveAccess::Middleware
      end
    end

    def use_active_access?
      ActiveAccess.config.enabled?
    end

    def app
      Rails.application
    end
  end
end
