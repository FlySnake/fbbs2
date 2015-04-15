class BuildArtefact < ActiveRecord::Base
  belongs_to :build_job
  mount_uploader :file, BuildArtefactUploader
  
  def visible?
    if self.build_job.nil?
      true
    else
      not TestsResult.tests_artefact? self.filename, build_job.enviroment.tests_executor
    end
  end
  
end
