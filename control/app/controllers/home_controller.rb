class HomeController < ApplicationController
  before_filter :set_enviroments
  before_filter :set_home_page_contents
  skip_before_filter :authenticate_user!
  
  def index
  end
  
  private
  
    def set_enviroments
      @enviroments = Enviroment.all
    end
    
    def set_home_page_contents
      @home_page_contents = HomePageContent.all
    end
  
end
