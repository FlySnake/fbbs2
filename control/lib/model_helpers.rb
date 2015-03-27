module ModelHelpers
  def without_sql_logging
    old_logger = ActiveRecord::Base.logger
    ActiveRecord::Base.logger = nil
    yield
    ActiveRecord::Base.logger = old_logger
  end
 
  def attr_accessor_with_onchange_callback(*args, &block)
    raise 'Callback block is required' unless block
    args.each do |arg|
      attr_name = arg.to_s
      define_method(attr_name) do
         self.instance_variable_get("@#{attr_name}")
      end
      define_method("#{attr_name}=") do |argument|
        old_value = self.instance_variable_get("@#{attr_name}")
        if argument != old_value
          self.instance_variable_set("@#{attr_name}", argument)
          self.instance_exec(attr_name, argument, old_value, &block)
        end
      end   
    end
  end
  
  class QueueWithTimeout
    def initialize
      @mutex = Mutex.new
      @queue = []
      @recieved = ConditionVariable.new
    end
   
    def push(x)
      @mutex.synchronize do
        @queue << x
        @recieved.signal
      end
    end
    
    def <<(x)
      push x
    end
   
    def pop(non_block = false)
      pop_with_timeout(non_block ? 0 : nil)
    end
   
    def pop_with_timeout(timeout = nil)
      @mutex.synchronize do
        if @queue.empty?
          @recieved.wait(@mutex, timeout) if timeout != 0
          #if we're still empty after the timeout, raise exception
          raise ThreadError, "queue empty" if @queue.empty?
        end
        @queue.shift
      end
    end
  end
  
end