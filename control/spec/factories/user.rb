FactoryGirl.define do
  factory :user do
    email { Faker::Internet.email }
    admin false
    password { Faker::Internet.password(8, 16)}
  end
end