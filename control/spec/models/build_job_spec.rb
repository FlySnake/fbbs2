require 'rails_helper'

RSpec.describe BuildJob, type: :model do
  it "has a valid factory" do
    expect(build(:build_job)).to be_valid
  end
  
  it "is invalid without branch" do
    expect(build(:build_job, :branch => nil)).to be_invalid
  end
  
  it "is invalid with invalid branch" do
    expect(build(:build_job, :branch_id => "")).to be_invalid
  end
  
  it "is invalid with invalid branch #2" do
    expect(build(:build_job, :branch_id => "100500")).to be_invalid
  end
  
  it "is invalid without base_version" do
    expect(build(:build_job, :base_version => nil)).to be_invalid
  end
  
  it "is invalid with invalid base_version" do
    expect(build(:build_job, :base_version_id => "100500")).to be_invalid
  end
  
  it "is invalid without enviroment" do
  expect(build(:build_job, :enviroment_id => nil)).to be_invalid
  end
  
  it "is invalid without target platform" do
    expect(build(:build_job, :target_platform_id => nil)).to be_invalid
  end
  
  it "is valid with empty comment" do
    expect(build(:build_job, :comment => "")).to be_valid
  end
  
  it "is invalid with too long comment" do
    expect(build(:build_job, :comment => Faker::Lorem.characters(1024))).to be_invalid
  end
  
end
