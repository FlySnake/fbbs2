class FullVersion < ActiveRecord::Base
  has_many :build_jobs
end
