class Admin::<%= @model_name.pluralize %>Controller < Admin::AdminController
  include Nextro::CrudableConcern

  protected

  def resource_permited_params
    [<%= @keys.map { |k| ":#{k}" }.join(", ") %>]
  end

  def resource_title
    resource.id
  end
end
