class TestsExecutor < ActiveRecord::Base
  has_many :enviroments
  has_many :tests_results
  
  validates :title, length: {in: 1..100}, uniqueness: true
  validates :run_params, length: {in: 1..512}
  validates :artefact_name, length: {in: 1..512}, :format => {:with => /(\.|\/)(zip)/i, :message => "should ends with zip"}
end
