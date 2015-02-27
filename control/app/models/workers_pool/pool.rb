require 'singleton'
require 'thread'

class WorkersPool::Pool
  include Singleton
  
  def initialize
    @semaphore = Mutex.new
    load_workers
  end
  
  def ready_workers
    @workers.select {|w| w.status == :ready}
  end
  
  def load_workers
    Rails.logger.debug("Loading all workers")
    @semaphore.synchronize {
      @workers = Worker.all
    }
  end
  
  def poll_all
    @workers.each do |w|
      w.poll
    end
  end
  
end