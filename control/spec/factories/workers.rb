FactoryGirl.define do
  factory :worker do
    title { Faker::Name.name }
    address { Faker::Internet.ip_v4_address + ":" + Faker::Number.number(4) }
    priority 0
  end
end