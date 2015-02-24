class BuildJob < ActiveRecord::Base
  belongs_to :branch
  belongs_to :base_version
  belongs_to :target_platform
  belongs_to :enviroment
  belongs_to :notify_user, foreign_key: :notify_user_id, class_name: User
  belongs_to :started_by_user, foreign_key: :started_by_user_id, class_name: User
  
  enum status: [:ready, :busy]
end
