FactoryGirl.define do
  factory :release_version do
    name { Faker::Number.number(3) }
  end

end
