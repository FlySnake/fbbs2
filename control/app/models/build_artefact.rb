class BuildArtefact < ActiveRecord::Base
  belongs_to :build_job
  mount_uploader :file, BuildArtefactUploader
  
end
