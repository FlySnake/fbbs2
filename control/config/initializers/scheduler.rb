if defined?(Rails::Console) or defined?(Rails::Generators) or File.basename($0) == "rake"
  # skip console, rails generators and rake
else
  require 'rufus-scheduler'
 
  scheduler = Rufus::Scheduler.new
  
  scheduler.in '3s' do
    start_theads
  end
 
  #scheduler.every '5s' do
  #  Worker.poll_all
  #end
  
  #scheduler.every '1s' do
  #  BuildJobQueue.check!
  #end
  

  
end

def start_theads
  Thread.new do
    loop do
      BuildJobQueue.check!
      sleep 1
    end
  end
  
  Thread.new do
    loop do
      Worker.poll_all
      sleep 5
    end
  end
end