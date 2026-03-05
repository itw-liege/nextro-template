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
        empty_directory "app/views/layouts"
        copy_file "views/layouts/devise.html.erb", "app/views/layouts/devise.html.erb"
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

      def create_users_controller
        template "controllers/users_controller.rb", "app/controllers/admin/users_controller.rb"
        empty_directory "app/views/admin/users"
        copy_file "views/admin/users/index.html.erb", "app/views/admin/users/index.html.erb"
      end

      def configure_devise_layout
        inject_into_class "app/controllers/application_controller.rb", "ApplicationController", <<~RUBY

  layout :layout_by_resource

  private

  def layout_by_resource
    if devise_controller?
      "devise"
    else
      "application"
    end
  end
RUBY
      rescue StandardError
        say "  → Ajoutez manuellement layout 'devise' pour les contrôleurs Devise (voir README)", :yellow
      end

      def add_routes
        route <<~ROUTES

          namespace :admin do
            root to: "dashboard#index"
            resources :users, only: [:index]
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
        say "  2. La route users et le contrôleur sont créés par défaut"
        say "  3. Personnalisez app/views/admin/admin/_sidebar_left.html.erb"
        say "  4. Créez User avec Devise si pas déjà fait : rails g devise User"
        say "  5. Pour un CRUD : rails g nextro_template:admin:crud nom name:string"
        say "  6. Layout Devise configuré. Personnalisez : rails g devise:views"
        say ""
      end
    end
  end
end
