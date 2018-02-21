# frozen_string_literal: true

module ActiveAccess
  class Railtie < Rails::Railtie
    initializer "active_access.configure_rails_initialization" do
      if use_better_errors?
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

    def use_better_errors?
      !Rails.env.production? && app.config.consider_all_requests_local
    end

    def app
      Rails.application
    end
  end
end
