class TargetPlatform < ActiveRecord::Base
  has_and_belongs_to_many :workers
  has_many :build_jobs
end
