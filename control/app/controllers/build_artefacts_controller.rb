class BuildArtefactsController < ApplicationController
  def show
    @artefact = BuildArtefact.find_by(:filename => params[:filename])
    if @artefact.nil?
      render :show
    else
      if @artefact.build_job.status == 'busy'
        redirect_to build_job_path(:id => @artefact.build_job.id, :enviroment_title => params[:enviroment_title]), 
                    flash: {warning: "The job is not finished yet."}
      else
        if @artefact.file.nil? or @artefact.file.url.nil?
          redirect_to build_job_path(:id => @artefact.build_job.id, :enviroment_title => params[:enviroment_title]), 
                      flash: {error: "It appears like there is no artefacts for this build job. Maybe it has failed or something like that."}
        else
          redirect_to @artefact.file.url
        end
      end
    end
  end
end
