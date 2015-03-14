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
    title = Faker::Lorem.word
    create(:worker, :title => title)
    expect(build(:worker, :title => title)).to be_invalid
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
    addr = "http://192.168.1.1:12345"
    create(:worker, :address => addr)
    expect(build(:worker, :address => addr)).to be_invalid
  end
  
  it "corrects address with slash at the end" do
    addr = "http://example.com:40100/"
    w = create(:worker, :address => addr)
    expect(w.address).to eq "http://example.com:40100"
  end
  
end
