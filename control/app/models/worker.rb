class Worker < ActiveRecord::Base
  has_and_belongs_to_many :target_platforms
  has_many :build_jobs
  
  validates :title, length: {in: 1..100}, uniqueness: true
  validates :address, length: {in: 2..100}, uniqueness: true
  
  enum status: [:offline, :ready, :busy]
  
  def self.poll_all
    without_sql_logging do
      Worker.all.each do |w|
        w.poll
      end
    end
  end
  
  def poll
    #puts "polling #{self.title}"
  end
  
  def start!
    Rails.logger.info("Starting worker #{self.title}")
    update_attribute(:status, :busy)
  end
  
  def stop!
    
  end
  
  def request_config!
    # TODO implement this. also remember to implement target_platfroms caching
    true
  end
  
  private 
  

  
end
