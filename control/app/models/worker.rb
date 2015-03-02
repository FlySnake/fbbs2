require 'jsonclient'

class Worker < ActiveRecord::Base
  has_and_belongs_to_many :target_platforms
  has_many :build_jobs
  
  validates :title, length: {in: 1..100}, uniqueness: true
  validates :address, length: {in: 2..100}, uniqueness: true
  
  after_save :reload_pool
  after_destroy :reload_pool
  before_create :request_config_on_create
  
  attr_accessor_with_onchange_callback :status, :result, :artefacts, :commit_info, :build_log, :enviroment_id, :run_duration do |attr_name, value|
    status_changed attr_name.to_sym
  end
  
  def poll
    Rails.logger.debug("Polling worker '#{self.title}@#{self.address}'")
    
    begin
      status_msg = get_status
      if status_msg.nil?
        self.status = :offline
      else
        self.status = status_msg['busy'] ? :busy : :ready
        self.result = status_msg['error'] ? :failure : :success
        #self.artefacts = 
      end
    
    rescue => err
      Rails.logger.error("Error fetching worker status: #{err.to_s}")
    end
    
  end
  
  def start!(params)
    Rails.logger.info("Starting worker '#{self.title}@#{self.address}'")
    
    enviroment_id = params[:enviroment_id]
    target_platform = params[:target_platform]
    
    self.status = :busy
    start_build
  end
  
  def stop!
    Rails.logger.info("Stopping worker '#{self.title}@#{self.address}'")
  end
  
  def request_config!
    begin
      worker_config = get_config
  
      platforms = []
      worker_config['build']['platforms'].each do |p|
        platforms << TargetPlatform.find_or_create_by!(title: p)
      end
      self.target_platforms = platforms
      save
    rescue => err
      Rails.logger.error("Error fetching worker config: #{err.to_s}")
      self.errors.add(:worker_config, err.to_s)
      false
    end
  end
  
  private 
  
  def request_config_on_create
    request_config!
    true # always ok because we don't care in create callback
  end
  
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
    data = JSONClient.new.get "#{full_base_address}/build"
    data.content
  end
  
  def get_config
    data = JSONClient.new.get "#{full_base_address}"
    data.content
  end
  
  def start_build
    
  end
  
  def stop_build
    
  end
  
end