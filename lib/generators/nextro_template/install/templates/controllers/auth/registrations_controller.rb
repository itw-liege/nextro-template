# frozen_string_literal: true

class Auth::RegistrationsController < Devise::RegistrationsController
  layout "admin", only: [:edit, :update]

  before_action :add_my_account_breadcrumb, only: [:edit, :update]

  private

  def add_my_account_breadcrumb
    add_breadcrumb I18n.t("nextro.breadcrumbs.my_account", default: "Mon compte"), [:admin, :users] if respond_to?(:add_breadcrumb)
  end
end
