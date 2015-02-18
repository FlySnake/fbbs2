class AdminController < ApplicationController
  before_filter :authenticate_user!
  before_filter :check_user_admin
  
  def index
    @users = User.all
  end
  
  private
  
  def check_user_admin
    redirect_to root_path unless current_user and current_user.admin?
  end
  
end
