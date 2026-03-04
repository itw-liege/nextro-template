# frozen_string_literal: true

require "rails/engine"

module NextroTemplate
  class Engine < ::Rails::Engine
    # Pas de namespace isolé : les vues et helpers sont fusionnés avec l'app hôte

    config.generators do |g|
      g.test_framework :rspec
      g.fixture_replacement :factory_bot
      g.template_engine :erb
      g.stylesheets false
      g.javascripts false
      g.helper false
    end

    initializer "nextro_template.assets" do |app|
      if app.config.respond_to?(:assets)
        app.config.assets.precompile += %w[nextro_template.js nextro_template.css nextro.js nextro-datatables.js]
      end
    end

    initializer "nextro_template.i18n" do |_app|
      config.i18n.load_path += Dir[File.expand_path("../../config/locales/**/*.yml", __dir__)]
    end
  end
end
