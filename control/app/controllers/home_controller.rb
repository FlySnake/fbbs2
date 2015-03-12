class HomeController < ApplicationController
  before_filter :set_enviroments
  before_filter :set_home_page_contents
  
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
