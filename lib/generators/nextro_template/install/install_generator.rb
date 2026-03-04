# frozen_string_literal: true

module NextroTemplate
  module Generators
    class InstallGenerator < Rails::Generators::Base
      desc "Installe Nextro Template : copie les assets et configure l'application"

      source_root File.expand_path("templates", __dir__)

      def copy_stylesheets
        directory "assets/stylesheets/nextro_template", "app/assets/stylesheets/nextro_template"
        copy_file "assets/stylesheets/nextro_template.scss", "app/assets/stylesheets/nextro_template.scss"
      end

      def copy_javascripts
        copy_file "assets/javascripts/nextro.js", "app/assets/javascripts/nextro.js"
        copy_file "assets/javascripts/nextro-datatables.js", "app/assets/javascripts/nextro-datatables.js"
      end

      def copy_views
        empty_directory "app/views/admin/admin"
        copy_file "views/admin/admin/_sidebar_left.html.erb", "app/views/admin/admin/_sidebar_left.html.erb"
      end

      def create_assets_initializer
        create_file "config/initializers/nextro_template_assets.rb", <<~RUBY
          # Nextro Template - précompilation des assets
          if Rails.application.config.respond_to?(:assets)
            Rails.application.config.assets.precompile += %w[nextro_template.css nextro.js nextro-datatables.js]
          end
        RUBY
      end

      def create_admin_controller
        template "controllers/admin_controller.rb", "app/controllers/admin/admin_controller.rb"
      end

      def create_dashboard_controller
        empty_directory "app/controllers/admin"
        template "controllers/dashboard_controller.rb", "app/controllers/admin/dashboard_controller.rb"
        empty_directory "app/views/admin/dashboard"
        copy_file "views/admin/dashboard/index.html.erb", "app/views/admin/dashboard/index.html.erb"
      end

      def add_routes
        route <<~ROUTES

          namespace :admin do
            root to: "dashboard#index"
            resources :admin, only: [], controller: "admin" do
              get :set_language, on: :collection
            end
          end
        ROUTES
      end

      def show_next_steps
        say "\n" + "=" * 60, :green
        say "Nextro Template installé avec succès !", :green
        say "=" * 60, :green
        say "\nProchaines étapes :", :yellow
        say "  1. Vérifiez config/initializers/assets.rb"
        say "  2. Personnalisez app/views/admin/admin/_sidebar_left.html.erb"
        say "  3. Créez un modèle User avec Devise si pas déjà fait"
        say "  4. Pour un CRUD : rails g nextro_template:admin:crud nom name:string"
        say ""
      end
    end
  end
end
