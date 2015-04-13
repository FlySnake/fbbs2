require 'jsonclient'
require 'model_helpers'

class Worker < ActiveRecord::Base
  extend ModelHelpers
  
  has_and_belongs_to_many :target_platforms
  has_many :build_jobs
  
  validates :title, length: {in: 1..100}, uniqueness: true
  validates :address, length: {in: 2..100}, uniqueness: true
  validates :priority, numericality: { only_integer: true }
  
  after_save :reload_pool
  after_destroy :reload_pool
  after_create { request_config!; true }
  after_initialize { @failed_requests_count = 0 }
  
  attr_accessor_with_onchange_callback :status, :result, :artefacts, :full_version, :commit_info, :build_log, :run_duration do |attr_name, value, old_value|
    BuildJob.on_worker_status_changed self, attr_name.to_sym, value, old_value
  end
  
  def address=(val)
      write_attribute(:address, val.nil? ? nil : val.chomp('/'))
  end
  
  def humanize
    "#{self.title}@#{self.address}"
  end
  
  def poll
    Rails.logger.debug("Polling worker '#{humanize}'")
    msg = get_status
    update_status msg
  rescue => err
    Rails.logger.error("Error polling worker '#{humanize}': #{error_string err}")
    set_to_failure
  end
  
  def start!(params)
    Rails.logger.info("Starting worker '#{humanize}'")
    self.status = :busy #for sure
    begin
      msg = start_build(start_params(params[:branch_name], params[:target_platform_name], params[:enviroment_id], params[:base_version], params[:buildnum_service], params[:tests]))
      update_status msg
    rescue => err
      Rails.logger.error("Error starting worker '#{humanize}': #{error_string err}")
      set_to_failure
    end
  end
  
  def stop!
    Rails.logger.info("Stopping worker '#{humanize}'")
    msg = stop_build
    update_status msg
    true
  rescue => err
    Rails.logger.error("Error stopping worker '#{humanize}': #{error_string err}")
    set_to_failure
    false
  end
  
  def request_config!
    worker_config = get_config

    platforms = []
    worker_config['build']['platforms'].each do |p|
      platforms << TargetPlatform.find_or_create_by!(title: p)
    end
    self.target_platforms = platforms
    self.tests_support = worker_config['build']['tests_support']
    save
  rescue => err
    Rails.logger.error("Error fetching worker config: #{error_string err}")
    self.errors.add(:worker_config, err.to_s)
    false
  end
  
  def get_artefact(name)
    Rails.logger.info("Downloading artefact '#{name}' in worker '#{humanize}'")
    data = download_artefact name
    delete_artefact name
    data
  rescue => err
    Rails.logger.error("Error downloading artefact '#{name}' in worker '#{humanize}': #{error_string err}")
    nil
  end
  
  private 
  
    def set_to_failure
      if @failed_requests_count >= 3
        @failed_requests_count = 0
        if self.status != :offline
          Rails.logger.error("Worker '#{humanize}' goes offline after 3 retries")
          self.result = :failure
          self.status = :offline
        end
      else
        @failed_requests_count += + 1
      end
    end
    
    def reload_pool
      WorkersPool::Pool.instance.load_workers
    end
    
    def full_base_address
      self.address.start_with?("http") ? self.address : "http://#{self.address}"
    end
    
    def get_status
      data = create_json_client.get "#{full_base_address}/build"
      raise_on_error(data)
      data.content
    end
    
    def get_config
      data = create_json_client.get "#{full_base_address}"
      raise_on_error(data)
      data.content
    end
    
    def start_build params
      data = create_json_client.put "#{full_base_address}/build", :body => params
      raise_on_error(data)
      data.content
    end
    
    def stop_build
      data = create_json_client.delete "#{full_base_address}/build"
      raise_on_error(data)
      data.content
    end
    
    def download_artefact(name)
      data = create_json_client.get "#{full_base_address}/download/#{name}"
      raise_on_error(data)
      data.content
    end
    
    def delete_artefact(name)
      data = create_json_client.delete "#{full_base_address}/download/#{name}"
      raise_on_error(data)
      data.content
    end
    
    def start_params(branch, platform, enviroment_id, base_version, buildnum_service, tests)
      result = {'branch' => branch, 
                'platform' => platform, 
                'enviroment_id' => enviroment_id, 
                'base_version' => base_version, 
                'buildnum_service' => buildnum_service
                }
       unless tests.blank?
         result['params'] = {'tests_run_params' => tests[:run_params], 'tests_artefact_name' => tests[:artefact_name]}
       end
       result
    end
    
    def raise_on_error(data)
      raise "http status #{data.status.to_s}" if data.status != 200
    end
    
    def create_json_client
      client = JSONClient.new
      client.receive_timeout = 60
      client.connect_timeout = 30
      client.send_timeout = 40
      client
    end
    
    def error_string(err)
      "#{err.to_s} [#{err.class.to_s}]"
    end
    
    def update_status(msg)
      if msg['error']
        self.result = :failure
      else
        if msg['terminated']
          self.result = :terminated
        else
          self.result = :success
        end
      end
      self.run_duration = msg['run_duration']
      self.commit_info = msg['last_commit_info']
      self.full_version = msg['params']['full_version']
      self.artefacts = msg['params']['artefacts_names']
      self.build_log = msg['build_log']
      
      # must be last 
      self.status = msg['busy'] ? :busy : :ready
    rescue => err
      Rails.logger.error("Error updating worker status '#{humanize}': #{error_string err}")
    end

end
