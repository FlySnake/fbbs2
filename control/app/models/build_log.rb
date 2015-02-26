class BuildLog < ActiveRecord::Base
  has_one :build_job
end
