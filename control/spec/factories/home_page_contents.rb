FactoryGirl.define do
  factory :home_page_content do
    title { Faker::Company.name }
    link { Faker::Internet.url }
  end
end
