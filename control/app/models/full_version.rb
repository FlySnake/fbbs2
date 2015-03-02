class FullVersion < ActiveRecord::Base
  belongs_to :base_version
  belongs_to :build_number
  belongs_to :release_version
  has_many :build_jobs
  
  def assemble
    if release_version.nil?
      "#{base_version.name.to_s}.#{build_number.number.to_s}"
    else
      "#{base_version.name.to_s}.#{release_version.name.to_s}.#{build_number.number.to_s}"
    end
  end
    
end
