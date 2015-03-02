FactoryGirl.define do
  factory :branch do
    name { Faker::Lorem.word }
  end
end
