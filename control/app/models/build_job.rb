class BuildJob < ActiveRecord::Base
  belongs_to :branch
  belongs_to :base_version
  belongs_to :target_platform
  belongs_to :enviroment
  belongs_to :notify_user, foreign_key: :notify_user_id, class_name: User
  belongs_to :started_by_user, foreign_key: :started_by_user_id, class_name: User
  belongs_to :commit
  belongs_to :build_log
  belongs_to :worker
  belongs_to :full_version
  has_many :build_artefacts
  has_one :build_job_queue
  
  validates :branch, presence: true
  validates :enviroment, presence: true
  validates :target_platform, presence: true
  
  enum status: [:fresh, :busy, :ready]
  enum result: [:unknown, :success, :failure]
  
  after_create :enqueue_job
  after_save :call_scheduler
  
  def start!(worker)
    worker.start! :target_platform => self.target_platform, :enviroment_id => self.enviroment.id
    update_attributes(:started_at => Time.now, :worker => worker, :status => BuildJob.statuses[:busy])
  end
  
  def stop!
    self.worker.stop!
    update_attributes(:finished_at => Time.now, :status => :ready)
  end
  
  def self.on_worker_status_changed(worker, attr_name)
    build_jobs = where(:worker => worker, :status => BuildJob.statuses[:busy])
    if build_jobs.size > 1
      Rails.logger.error("More than 1 active job for worker '#{worker.title}': #{build_jobs.map{|b| b.id}.to_s}")
    end
    build_jobs.each do |build_job| # should be only one, but just in case...
      if worker.status == :ready
        build_job.status = BuildJob.statuses[:ready]
      end
    

      if worker.result == :success
        build_job.result = BuildJob.results[:success]
      elsif worker.result == :failure
        build_job.result = BuildJob.results[:failure]
      else
        build_job.result = BuildJob.results[:unknown]
      end
   
      if worker.artefacts.any?
        #TODO download them and attach downloaded files
        build_job.build_artefacts = worker.artefacts.map {|a| BuildArtefact.new(:file => a)}
      end
    
      #TODO
      Commit.new
   
      build_job.build_log = BuildLog.new(:text => worker.build_log)
      
      if attr_name == :run_duration
        build_job.touch
      end
      
      build_job.save
    end

  end
 
  private
   
  def enqueue_job
    BuildJobQueue.enqueue self #TODO validation if there any workers for such platform
  end
  
  def call_scheduler
    BuildJobQueue.scheduler
  end
  
end
