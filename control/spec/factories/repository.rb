FactoryGirl.define do
  factory :repository do
    title { Faker::Internet.domain_word }
    path  { Faker::Lorem.sentences }
    vcs_type Repository.vcs_types[:git]
  end
end