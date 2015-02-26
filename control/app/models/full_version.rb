class FullVersion < ActiveRecord::Base
  belongs_to :base_version
  belongs_to :build_number
  has_many :build_jobs
  
  def assemble
    #TODO return string constructed from BaseVersion and BuildNumber
  end
    
end
