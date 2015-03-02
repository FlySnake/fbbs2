require 'rails_helper'

RSpec.describe User, type: :model do
  it "has a valid factory" do
    expect(build(:user)).to be_valid
  end
  
  describe "password validations" do
    it "is invalid without password" do
      expect(build(:user, :password => nil)).to be_invalid
    end
    
    it "is invalid with to short password" do
      expect(build(:user, :password => Faker::Internet.password(2, 7))).to be_invalid
    end
    
    it "is invalid with to long password" do
      expect(build(:user, :password => Faker::Internet.password(200, 202))).to be_invalid
    end
    
  end
  
  it "is invalid without email" do
    expect(build(:user, :email => nil)).to be_invalid
  end
  
  it "is invalid with wrong email" do
    expect(build(:user, :email => Faker::Lorem.word)).to be_invalid
  end
  
end
