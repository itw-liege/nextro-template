# frozen_string_literal: true

module NextroTemplate
  module Generators
    module Admin
      class CrudGenerator < Rails::Generators::Base
      argument :name, required: true
      argument :fields, type: :array, default: [], banner: "field:type field:type"

      def create_crud_files
        @singular = name.singularize
        @model_name = @singular.camelcase
        @collection = @singular.pluralize

        @fields = fields.map do |field|
          key = field.split(":").first
          type = (field.split(":").second || "string").to_sym
          { key: key, type: type }
        end

        @keys = fields.map { |f| f.split(":").first }

        template "controller.rb", "app/controllers/admin/#{@collection}_controller.rb"
        template "views/index.html.erb", "app/views/admin/#{@collection}/index.html.erb"
        template "views/new.html.erb", "app/views/admin/#{@collection}/new.html.erb"
        template "views/edit.html.erb", "app/views/admin/#{@collection}/edit.html.erb"
        template "views/_form.html.erb", "app/views/admin/#{@collection}/_form.html.erb"
        template "views/_list.html.erb", "app/views/admin/#{@collection}/_list.html.erb"

        route "resources :#{@collection}", namespace: :admin

        say "\nPensez à ajouter le menu dans app/views/admin/admin/_sidebar_left.html.erb :", :yellow
        say "  <%= menu_link(t('admin.#{@collection}.sidebar_left_title'), [:admin, :#{@collection}], \"#{@collection}\", \"fa-th-large\") %>", :green
      end

      def self.source_root
        File.expand_path("../templates", __dir__)
      end
    end
  end
end
