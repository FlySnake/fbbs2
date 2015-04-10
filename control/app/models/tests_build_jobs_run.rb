class TestsBuildJobsRun < ActiveRecord::Base
  belongs_to :build_job
  belongs_to :tests_result
end
