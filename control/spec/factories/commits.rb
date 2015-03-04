FactoryGirl.define do
  factory :commit do
    identifier { Faker::Bitcoin.address }
    datetime { Time.now }
    message { Faker::Lorem.sentence }
    author { Faker::Name.name }
  end
end