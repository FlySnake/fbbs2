class RotateBuildJobsJob < ActiveJob::Base
  queue_as :default

  def perform(build_jobs_ids)
    unless build_jobs_ids.empty?
      BuildJob.destroy_all(:id => build_jobs_ids)
    end
  end
end
