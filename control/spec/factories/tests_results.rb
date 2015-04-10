FactoryGirl.define do
  factory :tests_result do
    title { Faker::Lorem.sentence }
    data { Faker::Lorem.sentence } 
  end

end