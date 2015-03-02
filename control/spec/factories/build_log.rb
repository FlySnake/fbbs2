FactoryGirl.define do
  factory :build_log do
    text { Faker::Lorem.paragraph(100000) }
  end
end