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
    @workers.select {|w| w.status == :ready}
  end
  
  def find(worker)
    if worker.kind_of? Worker
      @workers.find {|w| w.id == worker.id}
    else
      worker = worker.to_i
      @workers.find {|w| w.id == worker}
    end
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