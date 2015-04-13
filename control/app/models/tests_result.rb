class TestsResult < ActiveRecord::Base
  belongs_to :tests_executor
  belongs_to :build_job
  
  attr_accessor :short_description, :result, :time
  
end
