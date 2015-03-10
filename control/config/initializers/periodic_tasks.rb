if defined?(Rails::Console) or defined?(Rails::Generators) or File.basename($0) == "rake"
  # skip console, rails generators and rake
else
  require 'rufus-scheduler'
 
  scheduler = Rufus::Scheduler.new
  
  scheduler.in '3s' do
    Thread.new do
      loop do
        begin
          #WorkersPool::Pool.instance.poll_all
          sleep 4
        rescue => err
          Rails.logger.error("Unhandled exception in 'WorkersPool::Pool.instance.poll_all': #{err.to_s}")
        end
      end
    end
  end
 
  scheduler.every '30s' do
    #WorkersPool::Timeout.new.check!
  end
  
  #scheduler.every '2s' do
  #  without_sql_logging do
  #    begin
  #      BuildJobQueue.scheduler
  #    rescue => err
  #      Rails.logger.error("Unhandled exception in 'BuildJobQueue.scheduler': #{err.to_s}")
  #    end
  #  end
  #end
 
end
