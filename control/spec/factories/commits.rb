FactoryGirl.define do
  factory :commit do
    identifier { Faker::Lorem.paragraph(100000) }
    datetime { Time.now }
    message { Faker::Lorem.sentence }
    author { Faker::Name.name }
  end
end