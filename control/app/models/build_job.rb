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
    worker.start!(:target_platform_name => self.target_platform.title, 
                  :enviroment_id => self.enviroment.id, 
                  :branch_name => self.branch.name, 
                  :base_version => self.base_version.name)
    update_attributes(:started_at => Time.now, :worker => worker, :status => BuildJob.statuses[:busy])
  end
  
  def stop!
    self.worker.stop!
    update_attributes(:finished_at => Time.now, :status => :ready)
  end
  
  def self.on_worker_status_changed(worker, attr_name, new_value, old_value)
    if attr_name == :status and new_value == :ready and (old_value == :offline or old_value.nil?)
      # when one of the workers goes online we have to call scheduler
      BuildJobQueue.scheduler
    end
    
    build_jobs = where(:worker => worker, :status => BuildJob.statuses[:busy])
    Rails.logger.error("More than 1 active job for worker '#{worker.title}': #{build_jobs.map{|b| b.id}.to_s}") if build_jobs.size > 1
    
    build_jobs.each do |build_job| # should be only one, but just in case...
      if attr_name == :status and old_value == :busy and new_value == :ready
        # worker completed
        if worker.result == :success
          build_job.result = BuildJob.results[:success]
        elsif worker.result == :failure
          build_job.result = BuildJob.results[:failure]
        else
          build_job.result = BuildJob.results[:unknown]
        end
        Rails.logger.debug "Worker '#{worker.title}' completed the job with result: #{build_job.result.to_s}"
        
        build_job.build_log = BuildLog.new(:text => worker.build_log)
        build_job.status = BuildJob.statuses[:ready]
        build_job.finished_at = Time.now
        #TODO download artefacts and attach downloaded files
      end
      
      if attr_name == :commit_info
        build_job.commit = Commit.find_or_create_by(:identifier => new_value['commit'], :datetime => Time.parse(new_value['datetime']), :message => new_value['text'], :author => new_value['author'])
      end
      
      if attr_name == :full_version
        build_job.full_version = FullVersion.find_or_create_by(:title => new_value)
      end
   
      if not worker.artefacts.nil? and worker.artefacts.any?
        if build_job.build_artefacts.empty?
          build_job.build_artefacts = worker.artefacts.map {|a| BuildArtefact.find_or_create_by(:file => a)}
        end
      end
   
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
