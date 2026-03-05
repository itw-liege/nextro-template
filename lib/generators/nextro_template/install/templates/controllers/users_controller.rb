class Admin::UsersController < Admin::AdminController
  add_breadcrumb I18n.t("admin.users.sidebar_left_title", default: "Utilisateurs"), [:admin, :users]

  before_action :set_page_title, only: [:index, :new, :edit]

  def index
    @users = defined?(User) ? User.all : []
  end

  def new
    return redirect_to admin_users_path unless defined?(User)
    @user = User.new
  end

  def create
    return redirect_to admin_users_path unless defined?(User)
    @user = User.new(user_params)
    if @user.save
      redirect_to admin_users_path, notice: t("admin.users.flash.created", default: "Utilisateur créé")
    else
      render :new
    end
  end

  def edit
    return redirect_to admin_users_path unless defined?(User)
    @user = User.find(params[:id])
  end

  def update
    return redirect_to admin_users_path unless defined?(User)
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to admin_users_path, notice: t("admin.users.flash.updated", default: "Utilisateur mis à jour")
    else
      render :edit
    end
  end

  def destroy
    return redirect_to admin_users_path unless defined?(User)
    User.find(params[:id]).destroy
    redirect_to admin_users_path, notice: t("admin.users.flash.deleted", default: "Utilisateur supprimé")
  end

  private

  def set_page_title
    @page_title = case action_name
    when "index" then I18n.t("admin.users.sidebar_left_title", default: "Utilisateurs")
    when "new", "create" then I18n.t("nextro.breadcrumbs.new", default: "Nouveau")
    when "edit", "update" then I18n.t("nextro.breadcrumbs.edit", default: "Modifier")
    else I18n.t("admin.users.sidebar_left_title", default: "Utilisateurs")
    end
  end

  def user_params
    params.require(:user).permit(:email, :firstname, :lastname, :password, :password_confirmation)
  end
end
