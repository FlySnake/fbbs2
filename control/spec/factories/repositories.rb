FactoryGirl.define do
  factory :repository do
    title { Faker::Internet.domain_word }
    path Rails.root.to_s.sub("control", "") #NOTE: assuming we are in control/ subdirectory of a repository
    vcs_type Repository.vcs_types[:git]
    weblink_to_commit { Faker::Internet.url + "/:commit"}
  end
end