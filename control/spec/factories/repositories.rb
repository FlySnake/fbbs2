FactoryGirl.define do
  factory :repository do
    title { Faker::Internet.domain_word }
    path  { Faker::Lorem.sentences }
    vcs_type Repository.vcs_types[:git]
    weblink_to_commit { Faker::Internet.url + "/:commit"}
  end
end