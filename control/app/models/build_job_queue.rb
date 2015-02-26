class BuildJobQueue < ActiveRecord::Base
  belongs_to :build_job
  
  def self.check!
    
      begin
        check_and_start
        check_and_finilize
      rescue => err
        Rails.logger.error("Error checking queue: #{err.to_s}")
      end
  end
  
  def self.enqueue(build_job)
    create(:build_job => build_job)
  end
  
  def self.dequeue(build_job)
    destroy_all(:build_job => build_job)
  end
  
  private
  
  def self.check_and_start
    without_sql_logging do
      fresh_jobs = BuildJob.includes(:target_platform).joins(:build_job_queue).fresh
      available_workers = Worker.ready
  
      fresh_jobs.each do |build_job|
        available_workers.each do |worker|
          if worker.target_platforms.include? build_job.target_platform
            build_job.start! worker
            dequeue build_job
          end
        end
      end
      
    end
  end
  
  def self.check_and_finilize
    without_sql_logging do
      busy_jobs = BuildJob.joins(:worker).where("build_jobs.status = ?", BuildJob.statuses[:busy])
      
      busy_jobs.each do |build_job|
        case build_job.worker[:status]
        when Worker.statuses[:ready]
          # Done
        when Worker.statuses[:busy]
          # Not finished yet
        when Worker.statuses[:offline]
          # Something very bad happen
        else
          raise "unknown worker status"
        end
      end
      
    end
  end
  
end
