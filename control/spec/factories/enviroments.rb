FactoryGirl.define do
  factory :enviroment do
    title { Faker::Hacker.adjective }
    default_build_number 0
    branches_filter ""
    delete_build_jobs_older_than 0
    association :repository
    association :issue_tracker
  end
end