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
  belongs_to :full_verision
  has_many :build_artefacts
  has_one :build_job_queue
  
  enum status: [:fresh, :busy, :ready]
  enum result: [:unknown, :success, :failure]
  
  after_create :enqueue_job
  
  def start!(worker)
    worker.start!
    update_attributes(:started_at => Time.now, :worker => worker, :status => :busy)
  end
  
  def stop!
    self.worker.stop!
    update_attributes(:finished_at => Time.now, :status => :ready)
  end
 
 
  private
   
  def enqueue_job
    BuildJobQueue.enqueue self #TODO validation if there any workers for such platform
  end
  
end
