class Commit < ActiveRecord::Base
  has_one :build_job
  
  def extract_issue(regex)
    Regexp.new(regex).match(self.message).to_s
  end
  
  def humanize
    "#{identifier} | #{author} | #{datetime} | #{message}"
  end
  
end
