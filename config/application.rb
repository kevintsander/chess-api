require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module RailsChessApi
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    config.api_only = true

    chess_engine_unit_classes = ChessEngine::Units.constants.select do |c|
      ChessEngine::Units.const_get(c).is_a? Class
    end
    chess_engine_unit_classes_with_namespace = chess_engine_unit_classes.map { |c| ChessEngine::Units.const_get(c) }

    chess_engine_action_classes = ChessEngine::Actions.constants.select do |c|
      ChessEngine::Actions.const_get(c).is_a? Class
    end
    chess_engine_action_classes_with_namespace = chess_engine_action_classes.map do |c|
      ChessEngine::Actions.const_get(c)
    end
    config.active_record.yaml_column_permitted_classes = [Symbol, ChessEngine::Game, ChessEngine::Board,
                                                          *chess_engine_unit_classes_with_namespace, *chess_engine_action_classes_with_namespace]

    config.session_store :cookie_store, key: '_interslice_session'
    config.middleware.use ActionDispatch::Cookies
    config.middleware.use config.session_store, config.session_options
  end
end
