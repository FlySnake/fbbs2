require 'rails_helper'

RSpec.describe Worker, type: :model do
  it "has a valid factory" do
    expect(build(:worker)).to be_valid
  end
  
  it "is invalid without title" do
    expect(build(:worker, :title => nil)).to be_invalid 
  end
  
  it "is invalid with too short title" do 
    expect(build(:worker, :title => Faker::Lorem.characters(0))).to be_invalid
  end
  
  it "is invalid with too long title" do
    expect(build(:worker, :title => Faker::Lorem.characters(101))).to be_invalid
  end
  
  it "is invalid with duplicate title" do
    create(:worker, :title => "hello")
    expect(build(:worker, :title => "hello")).to be_invalid
  end
  
  it "is invalid without address" do
    expect(build(:worker, :address => nil)).to be_invalid
  end
  
  it "is invalid with too short address" do
    expect(build(:worker, :address => Faker::Lorem.characters(1))).to be_invalid
  end
  
  it "is invalid with too long address" do
    expect(build(:worker, :address => Faker::Lorem.characters(204))).to be_invalid
  end
  
  it "is invalid with duplicate address" do
    create(:worker, :address => "192.168.1.1:12345")
    expect(build(:worker, :address => "192.168.1.1:12345")).to be_invalid
  end
  
end
