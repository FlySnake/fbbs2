class HomeController < ApplicationController
  before_filter :set_enviroments
  
  def index
  end
  
  private
  
  def set_enviroments
    @enviroments = Enviroment.all
  end
  
end
