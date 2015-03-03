require 'jsonclient'

class Worker < ActiveRecord::Base
  has_and_belongs_to_many :target_platforms
  has_many :build_jobs
  
  validates :title, length: {in: 1..100}, uniqueness: true
  validates :address, length: {in: 2..100}, uniqueness: true
  
  after_save :reload_pool
  after_destroy :reload_pool
  before_create :request_config_on_create
  
  attr_accessor_with_onchange_callback :status, :result, :artefacts, :full_version, :commit_info, :build_log, :run_duration do |attr_name, value, old_value|
    #Rails.logger.debug "#{attr_name} changed from #{old_value.to_s} to #{value.to_s} in worker with id:#{self.id.to_s}"
    BuildJob.on_worker_status_changed self, attr_name.to_sym, value, old_value
  end
  
  def poll
    Rails.logger.debug("Polling worker '#{self.title}@#{self.address}'")
    
    begin
      msg = get_status
      self.result = msg['error'] ? :failure : :success
      #msg['terminated']
      self.run_duration = msg['run_duration']
      self.commit_info = msg['last_commit_info']
      self.full_version = msg['params']['full_version']
      self.artefacts = msg['params']['artefacts_names']
      self.build_log = msg['build_log']
      
      # must be last 
      self.status = msg['busy'] ? :busy : :ready
      
    rescue => err
      Rails.logger.error("Error fetching worker status: #{err.to_s}")
      self.status = :offline
    end
  end
  
  def start!(params)
    Rails.logger.info("Starting worker '#{self.title}@#{self.address}'")
    begin
      resp = start_build(start_params(params[:branch_name], params[:target_platform_name], params[:enviroment_id], params[:base_version]))
      self.status = :busy
    rescue => err
      Rails.logger.error("Error starting worker: #{err.to_s}")
      self.status = :offline
    end
  end
  
  def stop!
    Rails.logger.info("Stopping worker '#{self.title}@#{self.address}'")
    begin
      resp = stop_build
    rescue => err
      Rails.logger.error("Error stopping worker: #{err.to_s}")
      self.status = :offline
    end
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
  
  def full_base_address
    self.address.start_with?("http") ? self.address : "http://#{self.address}"
  end
  
  def get_status
    data = JSONClient.new.get "#{full_base_address}/build"
    data.content
  end
  
  def get_config
    data = JSONClient.new.get "#{full_base_address}"
    data.content
  end
  
  def start_build params
    data = JSONClient.new.put "#{full_base_address}/build", :body => params
    data.content
  end
  
  def stop_build
    data = JSONClient.new.delete "#{full_base_address}/build"
    data.content
  end
  
  def start_params(branch, platform, enviroment_id, base_version)
    {'branch' => branch, 'platform' => platform, 'enviroment_id' => enviroment_id, 'base_version' => base_version}
  end

  
  
end