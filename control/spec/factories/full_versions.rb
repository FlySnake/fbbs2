FactoryGirl.define do
  factory :full_version do
    title { Faker::Number.number(10) }
  end
end