class FullVersion < ActiveRecord::Base
  belongs_to :base_version
  belongs_to :build_number
  has_many :build_jobs
  
  def assemble
    #TODO return string constructed from BaseVersion and BuildNumber and other (i.e. release number)
    "#{base_version.name.to_s}.#{build_number.number.to_s}"
  end
    
end
