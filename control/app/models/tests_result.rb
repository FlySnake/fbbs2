class TestsResult < ActiveRecord::Base
  belongs_to :tests_executor
  has_many :build_jobs, through: :tests_build_jobs_runs
end
