require "nextro_template"

class Admin::AdminController < ApplicationController
  include Nextro::PageTitleConcern
  include Nextro::CurrentControllerConcern

  before_action :authenticate_user! if respond_to?(:authenticate_user!, true)

  add_breadcrumb I18n.t("nextro.breadcrumbs.dashboard"), [:admin, :root]

  layout "admin"

  helper "admin/table"
  helper "admin/menu"
  helper "application/bootstrap"

  def set_language
    if respond_to?(:current_user) && current_user.respond_to?(:update)
      current_user.update(language: params[:language]) if params[:language].present?
    end
    I18n.locale = params[:language] || I18n.default_locale
    redirect_back(fallback_location: root_path)
  end
end
