FactoryGirl.define do
  factory :target_platform do
    title { Faker::Lorem.sentence }
    workers { [build(:worker)]  }
  end
end