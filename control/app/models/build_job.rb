require 'model_helpers'

class BuildJob < ActiveRecord::Base
  include ModelHelpers
  
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
  has_many :build_artefacts, dependent: :destroy
  has_one :build_job_queue
  has_many :tests_results, dependent: :destroy
  
  validates :branch, presence: true
  validates :enviroment, presence: true
  validates :target_platform, presence: true
  validates :base_version, presence: true
  validates :comment, length: {in: 0..256}
  validate :target_platform_tests
  
  enum status: [:fresh, :busy, :ready]
  enum result: [:unknown, :success, :failure, :terminated]
  
  after_create :enqueue_job
  after_save :call_scheduler
  after_save :notify
  before_destroy :stop!
  
  @@notify_queues = []
  @@notify_queues_mutex = Mutex.new
  class << self
    def on_change(queue)
      @@notify_queues_mutex.synchronize do
        @@notify_queues << queue
      end
      loop do
        @@notify_queues.each do
          yield
        end
      end
    end
  end
  
  def self.on_change_cleanup(queue)
    @@notify_queues_mutex.synchronize do
      @@notify_queues.delete(queue)
    end
    #ActiveRecord::Base.clear_active_connections!
  end
  
  scope :busy_with_worker, ->(worker) {
    busy.where(:worker => worker)
  }
  
  scope :with_branch_id, ->(branches_ids) {
    where(:branch_id => [*branches_ids])
  }
  
  scope :with_target_platform_id, ->(target_platforms_ids) {
    where(:target_platform_id => [*target_platforms_ids])
  }
  
  scope :with_base_version_id, ->(base_versions_ids) {
    where(:base_version_id => [*base_versions_ids])
  }
  
  filterrific(
    default_filter_params: { },
    available_filters: [
      :with_branch_id,
      :with_base_version_id,
      :with_target_platform_id
    ]
  )
  
  def start!(worker)
    worker.start!(:target_platform_name => self.target_platform.title, 
                  :enviroment_id => self.enviroment.id, 
                  :branch_name => self.branch.name, 
                  :base_version => self.base_version.name,
                  :buildnum_service => self.generate_build_numbers_url,
                  :tests => (self.run_tests ? {:run_params => self.enviroment.tests_executor.run_params, :artefact_name => self.enviroment.tests_executor.artefact_name} : nil))
    update_attributes(:started_at => Time.now, :worker => worker, :status => BuildJob.statuses[:busy])
  end
  
  def stop!
    BuildJobQueue.dequeue self
    if self.busy?
      self.worker.stop!
    elsif self.fresh?
      self.status = BuildJob.statuses[:ready]
      save
    end
  end
  
  def kill_by_timeout
    stop!
    update_attributes(:finished_at => Time.now, :status => :ready, :result => BuildJob.results[:failure])
  end
  
  def self.on_worker_status_changed(worker, attr_name, new_value, old_value)
    if attr_name == :status and new_value == :ready and (old_value == :offline or old_value.nil?)
      # when one of the workers goes online we have to call scheduler
      BuildJobQueue.scheduler
    end
    
    build_jobs = busy_with_worker(worker)
    Rails.logger.warn("More than 1 active job for worker '#{worker.title}': #{build_jobs.map{|b| b.id}.to_s}") if build_jobs.size > 1
    
    build_jobs.each do |build_job| # should be only one, but just in case...
      #puts "$$$$ #{attr_name}: #{old_value} -> #{new_value}"
      begin
        if attr_name == :status and old_value == :busy and (new_value == :ready or :offline)
          # worker completed or died
          build_job.finalize_result worker
          Rails.logger.debug "Worker '#{worker.title}' completed the job with result: #{build_job.result.to_s}"
          build_job.finalize_build_log worker
          build_job.finalize_status
          build_job.finalize_time
          build_job.download_artefacts
          build_job.send_notifications
  
        end
        
        if attr_name == :commit_info and not new_value.empty? and not new_value.nil?
            build_job.commit = Commit.find_or_create_by(:identifier => new_value['commit'], 
                                                        :datetime => Time.parse(new_value['datetime']), 
                                                        :message => new_value['text'], 
                                                        :author => new_value['author'])
        end
        
        if attr_name == :full_version and not new_value.nil?
          build_job.full_version = FullVersion.find_or_create_by(:title => new_value)
        end
     
        if attr_name == :artefacts and not new_value.nil?
          build_job.build_artefacts = new_value.map {|a| BuildArtefact.find_or_create_by(:filename => a)}
        end
     
        if attr_name == :run_duration
          # just update the updated_at column to prevent killing by timeout
          build_job.touch
        end
      rescue => err
        Rails.logger.error("Error updating build job status: #{err.to_s}")
      ensure
        build_job.save
      end
    end
  end
  
  def download_artefacts
    self.build_artefacts.each do |artefact|
      file = File.open("#{Dir.tmpdir}/#{artefact.filename}", 'wb')
      begin
        data = worker.get_artefact(artefact.filename)
        raise "nil data returned by worker" if data.nil?
        file.write(data)
        file.flush
        if self.run_tests and not self.enviroment.tests_executor.nil?
          if self.enviroment.tests_executor.artefact_name == artefact.filename #this is a tests result
            TestsResult.process_artefact file.path, self, self.enviroment.tests_executor
          end
        else
          artefact.file = file
          artefact.save
        end
      rescue => err
        Rails.logger.error("Error downloading artefact '#{artefact.filename}': #{err.to_s}")
      ensure
        file.close
        File.delete(file.path)
      end
    end
  end
  
  def finalize_result(worker)
    if worker.result == :success
      self.result = BuildJob.results[:success]
    elsif worker.result == :failure
      self.result = BuildJob.results[:failure]
    elsif worker.result == :terminated
      self.result = BuildJob.results[:terminated]
    else
      self.result = BuildJob.results[:unknown]
    end
  end
  
  def finalize_build_log(worker)
    self.build_log = BuildLog.new(:text => worker.build_log)
  end
  
  def finalize_status
    self.status = BuildJob.statuses[:ready]
  end
  
  def finalize_time
    self.finished_at = Time.now
  end
  
  def send_notifications
    unless self.notify_user.nil?
      Rails.logger.info "Sending email to #{self.notify_user.email} on finished job"
      SendNotifyUserEmailBuildJobFinishedJob.set(wait: 5.seconds).perform_later(self, self.notify_user)
    end
  end
 
  private
   
    def enqueue_job
      BuildJobQueue.enqueue self #TODO validation if there any workers for such platform
    end
    
    def call_scheduler
      BuildJobQueue.scheduler
    end
    
    def notify
      @@notify_queues.each do |q|
        q.push self
      end
    end
    
    def target_platform_tests
      if self.run_tests
        potential_workers = WorkersPool::Pool.instance.select_by_platform(self.target_platform)
        if potential_workers.empty? or not potential_workers.find {|w| w.tests_support }
          errors.add(:run_tests, "cannot run because there is no workers supporting them on selected platform")
        end
      end
    end
    
end
