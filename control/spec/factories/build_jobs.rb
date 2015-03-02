FactoryGirl.define do
  factory :build_job do
    association :branch
    association :target_platform
    association :enviroment
    association :base_version
    association :notify_user, factory: :user
    association :started_by_user, factory: :user
    status BuildJob.statuses[:fresh]
  end
end