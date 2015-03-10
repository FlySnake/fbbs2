require 'rails_helper'

RSpec.describe Enviroment, type: :model do
  it "has a valid factory" do
    expect(build(:enviroment)).to be_valid
  end
  
  it "is invalid without title" do
    expect(build(:enviroment, :title => nil)).to be_invalid
  end
  
  it "is invalid without default_build_number" do
    expect(build(:enviroment, :default_build_number => nil)).to be_invalid
  end
  
  it "is invalid without repository" do
    expect(build(:enviroment, :repository => nil)).to be_invalid
  end
  
  it "is invalid with to short title" do
    expect(build(:enviroment, :title => Faker::Lorem.characters(0))).to be_invalid
  end
  
  it "is invalid with to long title" do
    expect(build(:enviroment, :title => Faker::Lorem.characters(101))).to be_invalid
  end
  
  it "is invalid with non-numeric default_build_number" do
    expect(build(:enviroment, :default_build_number => "hello")).to be_invalid
  end
  
  it "is invalid with duplicate title" do
    create(:enviroment, :title => "hello world")
    expect(build(:enviroment, :title => "hello world")).to be_invalid
  end
  
end
