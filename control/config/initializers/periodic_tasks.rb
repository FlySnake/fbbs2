if defined?(Rails::Console) or defined?(Rails::Generators) or File.basename($0) == "rake"
  # skip console, rails generators and rake
else
  require 'rufus-scheduler'
 
  scheduler = Rufus::Scheduler.new
  
  scheduler.in '3s' do
    Thread.new do
      loop do
        begin
          WorkersPool::Pool.instance.poll_all
          sleep 4
        rescue => err
          Rails.logger.error("Unhandled exception in 'WorkersPool::Pool.instance.poll_all': #{err.to_s}")
        end
      end
    end
  end
 
  scheduler.every '30s' do
    begin
      WorkersPool::Timeout.new.check!
    rescue => err
      Rails.logger.error("Unhandled exception in 'WorkersPool::Timeout.new.check!': #{err.to_s}")
    end
  end
  
  scheduler.every '4h' do
    begin
      Repository.fetch_branches_all_in_backgroud
    rescue => err
      Rails.logger.error("Unhandled exception in 'Repository.fetch_branches_all_in_backgroud': #{err.to_s}")
    end
  end
  
  scheduler.every '24h' do
    begin
      Enviroment.rotate_build_jobs
    rescue => err
      Rails.logger.error("Unhandled exception in 'Enviroment.rotate_build_jobs': #{err.to_s}")
    end
  end
 
end
