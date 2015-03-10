class TargetPlatform < ActiveRecord::Base
  has_and_belongs_to_many :workers
  has_many :build_jobs
  
  scope :all_with_worker, -> {
    joins(:workers).group("target_platforms.id")
  }
  
  def self.options_for_select
    order('LOWER(title)').map { |e| [e.title, e.id] }
  end
  
end
