class HomeController < ApplicationController
  before_filter :authenticate_user!
  before_filter :set_enviroment, except: [:index]
  before_filter :set_enviroments
  
  def index
    if @enviroments.any?
      #TODO take from user's preferences
      redirect_to :action => :enviroments, :enviroment_title => @enviroments.first.title
    else
      redirect_to :enviroments, flash: {error: "You have to create at least one build enviroment."}
    end
  end
  
  def enviroments
    render template: "home/enviroment_home"
  end
  
  private
  
  def set_enviroment
    @enviroment = Enviroment.find_by(:title => params[:enviroment_title])
    if @enviroment.nil?
      raise "Unknown build enviroment '#{params[:enviroment_title]}'. Available: #{Enviroment.all.to_a.map{|e| e.title}.join(', ')}"
      # TODO something meaningful like redirect to an error page
    end
  end
  
  def set_enviroments
    @enviroments = Enviroment.all.order(:created_at => :asc)
  end
  
end
