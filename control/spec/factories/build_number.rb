FactoryGirl.define do
  factory :build_number do
    branch { Faker::Lorem.word }
    commit { Faker::Bitcoin.address }
    association :enviroment
    number { Faker::Number.number(5) } 
  end
end