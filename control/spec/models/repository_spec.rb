require 'rails_helper'

RSpec.describe Repository, type: :model do
  it "has a valid factory" do
    expect(build(:repository)).to be_valid
  end
  
  it "is invalid without title" do
    expect(build(:repository, :title => nil)).to be_invalid
  end
  
  it "is invalid without path" do 
    expect(build(:repository, :path => nil)).to be_invalid
  end
  
  it "is invalid without vcs_type" do 
    expect(build(:repository, :vcs_type => nil)).to be_invalid
  end
  
  it "is invalid with to long title" do
    expect(build(:repository, :title => Faker::Lorem.characters(101))).to be_invalid
  end
  
  it "is invalid with to short title" do
    expect(build(:repository, :title => Faker::Lorem.characters(0))).to be_invalid
  end
  
  it "is invalid with to short path" do
    expect(build(:repository, :path => Faker::Lorem.characters(0))).to be_invalid
  end
  
  it "is invalid with to long path" do
    expect(build(:repository, :path => Faker::Lorem.characters(4003))).to be_invalid
  end
  
  it "cannot be created with undefined vcs_type" do
    expect {build(:repository, :vcs_type => 123456789)}.to raise_error(ArgumentError)
  end
  
  it "is invalid with duplicate title" do
    create(:repository, :title => "hello world")
    expect(build(:repository, :title => "hello world")).to be_invalid
  end
  
end
