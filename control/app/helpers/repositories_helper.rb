module RepositoriesHelper
  def post_hook_full_url repository
    if repository.hook_login.blank? or repository.hook_password.blank?
      post_hook_repository_url repository
    else
      url_for :controller => :repositories, :action => :post_hook, :user => repository.hook_login, :password => repository.hook_password, :only_path => false
    end
  end
end
