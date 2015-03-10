FactoryGirl.define do
  factory :issue_tracker do
    title { Faker::Company.name }
    weblink { Faker::Internet.url + "/:issue"}
    regex '\d{3,10}'
  end
end
