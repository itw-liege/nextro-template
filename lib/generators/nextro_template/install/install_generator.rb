# frozen_string_literal: true

module NextroTemplate
  module Generators
    class InstallGenerator < Rails::Generators::Base
      desc "Installe Nextro Template : copie les assets et configure l'application"

      source_root File.expand_path("templates", __dir__)

      def copy_stylesheets
        directory "assets/stylesheets/nextro", "app/assets/stylesheets/nextro"
        directory "assets/stylesheets/nextro_template", "app/assets/stylesheets/nextro_template"
        copy_file "assets/stylesheets/nextro_template.scss", "app/assets/stylesheets/nextro_template.scss"
      end

      def copy_javascripts
        directory "assets/javascripts/nextro", "app/assets/javascripts/nextro"
        copy_file "assets/javascripts/nextro.js", "app/assets/javascripts/nextro.js"
        copy_file "assets/javascripts/nextro-datatables.js", "app/assets/javascripts/nextro-datatables.js"
      end

      def copy_views
        empty_directory "app/views/admin/admin"
        copy_file "views/admin/admin/_sidebar_left.html.erb", "app/views/admin/admin/_sidebar_left.html.erb"
        empty_directory "app/views/layouts"
        copy_file "views/layouts/devise.html.erb", "app/views/layouts/devise.html.erb"
      end

      def copy_devise_views
        empty_directory "app/views/devise/sessions"
        copy_file "views/devise/sessions/new.html.erb", "app/views/devise/sessions/new.html.erb"
        empty_directory "app/views/devise/registrations"
        copy_file "views/devise/registrations/new.html.erb", "app/views/devise/registrations/new.html.erb"
        copy_file "views/devise/registrations/edit.html.erb", "app/views/devise/registrations/edit.html.erb"
        empty_directory "app/views/devise/passwords"
        copy_file "views/devise/passwords/new.html.erb", "app/views/devise/passwords/new.html.erb"
        copy_file "views/devise/passwords/edit.html.erb", "app/views/devise/passwords/edit.html.erb"
        empty_directory "app/views/devise/shared"
        copy_file "views/devise/shared/_links.html.erb", "app/views/devise/shared/_links.html.erb"
        copy_file "views/devise/shared/_error_messages.html.erb", "app/views/devise/shared/_error_messages.html.erb"
      end

      def create_auth_registrations_controller
        return if File.exist?("app/controllers/auth/registrations_controller.rb")

        empty_directory "app/controllers/auth"
        copy_file "controllers/auth/registrations_controller.rb", "app/controllers/auth/registrations_controller.rb"
      end

      def configure_devise_registrations_controller
        routes_content = File.read("config/routes.rb")
        return if routes_content.include?("registrations: 'auth/registrations'") || routes_content.include?('registrations: "auth/registrations"')

        if routes_content.include?("devise_for :users")
          inject_into_file "config/routes.rb", ", controllers: { registrations: 'auth/registrations' }", after: "devise_for :users"
        end
      rescue StandardError
        say "  → Ajoutez manuellement controllers: { registrations: 'auth/registrations' } à devise_for (voir README)", :yellow
      end

      def copy_devise_locales
        empty_directory "config/locales"
        copy_file "config/locales/nextro_template.devise.en.yml", "config/locales/nextro_template.devise.en.yml"
        copy_file "config/locales/nextro_template.devise.fr.yml", "config/locales/nextro_template.devise.fr.yml"
      end

      def copy_images
        directory "assets/images/nextro", "app/assets/images/nextro"
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
        copy_file "views/admin/users/edit.html.erb", "app/views/admin/users/edit.html.erb"
        copy_file "views/admin/users/new.html.erb", "app/views/admin/users/new.html.erb"
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
        # Ne pas ajouter devise_for :users ici : le modèle User doit exister avant.
        # L'utilisateur doit exécuter "rails g devise:install" puis "rails g devise User" AVANT ce générateur.
        route <<~ROUTES
          root to: 'admin/dashboard#index'
          
          namespace :admin do
            root to: "dashboard#index"
            resources :users
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
        say "\nTemplate Nextro complet inclus (style, color, plugins, DataTables, Chosen)."
        say "\nProchaines étapes :", :yellow
        say "  1. Vérifiez config/initializers/assets.rb"
        say "  2. La route users et le contrôleur sont créés par défaut"
        say "  3. Personnalisez app/views/admin/admin/_sidebar_left.html.erb"
        say "  4. Si Devise n'était pas installé avant : rails g devise:install && rails g devise User && rails db:migrate"
        say "  5. Pour un CRUD : rails g nextro_template:admin:crud nom name:string"
        say "  6. Layout et vues Devise (login, signup, forgot password) copiés avec style Nextro"
        say ""
      end
    end
  end
end
