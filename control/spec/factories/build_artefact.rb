FactoryGirl.define do
  factory :build_artefact do
    file { Faker::Internet.slug }
  end
end