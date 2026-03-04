# frozen_string_literal: true

module Nextro
  module CrudableConcern
    extend ActiveSupport::Concern

    included do
      extend ClassMethods

      helper_method :resource, :resource_title, :collection, :collection_url,
                    :resource_url, :edit_resource_url, :new_resource_url,
                    :show?, :edit?, :new?

      before_action :build_breadcrumbs_from_path
    end

    def index; end

    def new
      @resource = begin_of_association_chain.new
      instance_variable_set("@#{singular_name}", @resource)
    end

    def create
      @resource = begin_of_association_chain.new(resource_params)
      if @resource.save
        redirect_to collection_url, notice: t("admin.#{plural_name}.flash.created")
      else
        flash.now[:error] = @resource.errors.full_messages
        render "new"
      end
    end

    def show; end

    def edit; end

    def update
      if resource.update(resource_params)
        redirect_to collection_url, notice: t("admin.#{plural_name}.flash.updated")
      else
        flash.now[:error] = resource.errors.full_messages
        render "edit"
      end
    end

    def destroy
      resource.destroy
      redirect_to collection_url, notice: t("admin.#{plural_name}.flash.deleted")
    end

    protected

    def build_breadcrumbs_from_path
      paths = current_path_array
      paths.each_with_index do |sub_path, index|
        next if index <= 0

        current_resource = begin
          paths[index - 1].classify.constantize.find_by(id: sub_path)
        rescue StandardError
          nil
        end
        add_breadcrumb breadcrumb_title_for_resource(current_resource), "/#{paths[0..index].join('/')}" unless current_resource.nil?
      end
    end

    def current_path_array
      paths = request.path.split("/").reject(&:empty?)
      case action_name
      when "new", "edit" then paths.pop
      end
      paths
    end

    def breadcrumb_title_for_resource(obj)
      obj.class.include?(BreadcrumbdableConcern) ? obj.breadcrumb_title : obj.class.name
    end

    def resource_permited_params
      raise NotImplementedError
    end

    def resource_class
      controller_name.classify.constantize
    end

    def plural_name
      controller_name.pluralize
    end

    def singular_name
      controller_name.singularize
    end

    def resource_title
      raise NotImplementedError
    end

    def collection
      @collection ||= begin_of_association_chain.all
    end

    def collection_url
      [:admin, plural_name.to_sym]
    end

    def resource_url(resource)
      [:admin, resource]
    end

    def edit_resource_url(resource)
      [:edit, :admin, resource]
    end

    def new_resource_url
      [:new, :admin, singular_name.to_sym]
    end

    def begin_of_association_chain
      resource_class
    end

    def resource
      @resource ||= begin_of_association_chain.find(params[:id])
    end

    def resource_params
      params.fetch(singular_name.to_sym, {}).permit(*resource_permited_params)
    end

    def show?
      action_name.to_sym == :show
    end

    def edit?
      action_name.to_sym == :edit
    end

    def new?
      %i[new create].include? action_name.to_sym
    end

    module ClassMethods; end
  end
end
