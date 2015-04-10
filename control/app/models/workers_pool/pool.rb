require 'singleton'
require 'thread'

class WorkersPool::Pool
  include Singleton
  
  def initialize
    @semaphore = Mutex.new
    load_workers
  end
  
  def all
    @workers
  end
  
  def ready
    @workers.select {|w| w.status == :ready and w.disabled == false }
  end
  
  def enabled
    @workers.select {|w| w.disabled == false}
  end
  
  def find(worker)
    if worker.kind_of? Worker
      @workers.find {|w| w.id == worker.id}
    else
      worker = worker.to_i
      @workers.find {|w| w.id == worker}
    end
  end
  
  def select_by_platform(platform)
    @workers.select {|w| w.target_platforms.include? platform}
  end
  
  def load_workers
    Rails.logger.debug("Loading all workers")
    @semaphore.synchronize {
      @workers = Worker.order(:priority => :desc).all
    }
  end
  
  def poll_all
    enabled.each do |w|
      begin
        w.poll
      rescue => err
        Rails.logger.error "Error polling worker '#{w.title}@#{w.address}': #{err.to_s}"
        Rails.logger.error err.backtrace.join("\n")
      end
    end
  end
  
end