# frozen_string_literal: true

module NextroTemplate
  module Generators
    class InstallGenerator < Rails::Generators::Base
      desc "Installe Nextro Template dans l'application"

      def add_routes
        route 'namespace :admin do
  root to: "dashboard#index"
  resources :admin do
    get :set_language, on: :collection
  end
end'
      end
    end
  end
end
