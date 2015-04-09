class TestsExecutor < ActiveRecord::Base
  has_many :enviroments
  
  validates :title, length: {in: 1..100}, uniqueness: true
end
