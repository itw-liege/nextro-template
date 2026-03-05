class Admin::DashboardController < Admin::AdminController
  before_action :set_page_title, only: [:index]

  def index
  end

  private

  def set_page_title
    @page_title = I18n.t("nextro.breadcrumbs.dashboard", default: "Tableau de bord")
  end
end
