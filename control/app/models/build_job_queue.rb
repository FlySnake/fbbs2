class BuildJobQueue < ActiveRecord::Base
  belongs_to :build_job
  
  def self.enqueue(build_job)
    create(:build_job => build_job)
  end
  
  def self.dequeue(build_job)
    destroy_all(:build_job => build_job)
  end
  
  def self.scheduler
    begin
      fresh_jobs = BuildJob.includes(:target_platform).joins(:build_job_queue).fresh
      available_workers = WorkersPool::Pool.instance.ready_workers
  
      fresh_jobs.each do |build_job|
        available_workers.each do |worker|
          if worker.target_platforms.include? build_job.target_platform
            build_job.start! worker
            dequeue build_job
          end
        end
      end
    rescue => err
      Rails.logger.error("Error checking queue: #{err.to_s}")
    end
  end
  
  private


end
