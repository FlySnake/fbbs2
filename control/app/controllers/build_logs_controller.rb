class BuildLogsController < ApplicationController
  def show
    @build_log = BuildLog.find(params[:id])
  end
end
