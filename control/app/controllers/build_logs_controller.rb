class BuildLogsController < ApplicationController
  def show
    @build_log = BuildLog.find(params[:id])
    respond_to do |format|
      format.html
      format.text
    end
  end
end
