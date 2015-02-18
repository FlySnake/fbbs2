class BaseAdminController < ApplicationController
  before_filter :check_user_admin
  
  private
  
  def check_user_admin
    if not current_user or not current_user.admin?
      redirect_to root_path, alert: 'You have to be admin in order to manage users accounts.'
    end
  end
end