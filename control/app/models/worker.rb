require 'jsonclient'

class Worker < ActiveRecord::Base
  has_and_belongs_to_many :target_platforms
  has_many :build_jobs
  
  validates :title, length: {in: 1..100}, uniqueness: true
  validates :address, length: {in: 2..100}, uniqueness: true
  
  after_save :reload_pool
  
  attr_accessor_with_onchange_callback :status, :result, :artefacts, :commit_info, :build_log, :enviroment_id, :run_duration do |attr_name, value|
    status_changed attr_name.to_sym
  end
  
  def poll
    Rails.logger.debug("Polling #{self.title}")
    
    status_msg = get_status
    if status_msg.nil?
      self.status = :offline
    else
      self.status = status_msg['busy'] ? :busy : :ready
      self.result = status_msg['error'] ? :failure : :success
      #self.artefacts
    end
    
  end
  
  def start!(params)
    Rails.logger.info("Starting worker #{self.title}")
    
    enviroment_id = params[:enviroment_id]
    target_platform = params[:target_platform]
    
    self.status = :busy
    start_build
  end
  
  def stop!
    
  end
  
  def request_config!
    # TODO implement this. also remember to implement target_platfroms caching
    true
  end
  
  private 
  
  def reload_pool
    WorkersPool::Pool.instance.load_workers
  end
  
  def status_changed(attr_name)
    BuildJob.on_worker_status_changed self, attr_name
  end
  
  def full_base_address
    self.address.include?("http") ? self.address : "http://#{self.address}"
  end
  
  def get_status
    begin
      data = JSONClient.new.get "#{full_base_address}/build"
      data.content
    rescue => err
      Rails.logger.error("Error fetching worker status: #{err.to_s}")
      nil
    end
  end
  
  def start_build
    
  end
  
  def stop_build
    
  end
  
end