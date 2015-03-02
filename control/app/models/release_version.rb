class ReleaseVersion < ActiveRecord::Base
  has_many :full_versions
end
