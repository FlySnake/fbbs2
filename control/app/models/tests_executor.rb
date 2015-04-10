class TestsExecutor < ActiveRecord::Base
  has_many :enviroments
  has_many :tests_results
  
  validates :title, length: {in: 1..100}, uniqueness: true
end
