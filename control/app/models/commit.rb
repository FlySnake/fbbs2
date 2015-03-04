class Commit < ActiveRecord::Base
  has_one :build_job
  
  def humanize
    "#{identifier} | #{author} | #{datetime} | #{message}"
  end
  
end
