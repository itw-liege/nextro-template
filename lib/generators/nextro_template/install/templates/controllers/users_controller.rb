class Admin::UsersController < Admin::AdminController
  def index
    @users = defined?(User) ? User.all : []
  end
end
