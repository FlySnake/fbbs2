FactoryGirl.define do
  factory :enviroment do
    title { Faker::Hacker.adjective }
    default_build_number 0
    branches_filter ""
    association :repository
    weblink_to_issue { Faker::Internet.url + "/:issue" }
  end
end