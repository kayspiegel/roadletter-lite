require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module RoadletterLite
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 8.1

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks])

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    # The admin area and the public pages each have their own locale source:
    # the admin's on the user, the newsletter's on the newsletter. Neither reads
    # the browser's language.
    config.i18n.available_locales = %i[ en de ]
    config.i18n.default_locale = :en

    # UUIDv7 primary keys, assigned in ApplicationRecord (SQLite has no generator).
    config.generators do |g|
      g.orm :active_record, primary_key_type: :uuid
    end
  end
end
