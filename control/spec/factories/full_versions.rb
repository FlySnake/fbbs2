FactoryGirl.define do
  factory :full_version do
    association :base_version
    association :build_number
    association :release_version
  end
end