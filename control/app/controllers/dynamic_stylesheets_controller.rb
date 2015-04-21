class DynamicStylesheetsController < ApplicationController
  skip_before_filter :authenticate_user!
  
  def index
    unless current_user.nil?
      @background_image_url = current_user.background_image_url #'http://placekitten.com/1500/1000'
      @opacity = current_user.background_image_opacity
      
      respond_to do |format|
        format.css { render :index, :content_type => "text/css" }
      end
    else
      render :nothing => true
    end
  end
  
end