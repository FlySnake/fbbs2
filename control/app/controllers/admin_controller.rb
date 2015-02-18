class AdminController < BaseAdminController
  before_filter :authenticate_user!
  
  def index
  end
  
end
