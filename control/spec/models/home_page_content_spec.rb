require 'rails_helper'

RSpec.describe HomePageContent, type: :model do
  it "has a valid factory" do
    expect(build(:home_page_content)).to be_valid
  end
  
  it "is invalid without title" do
    expect(build(:home_page_content, :title => nil)).to be_invalid
  end
  
  it "is invalid with too long title" do
    expect(build(:home_page_content, :title => Faker::Lorem.characters(10000))).to be_invalid
  end
  
  it "is invalid with too short title" do
    expect(build(:home_page_content, :title => "")).to be_invalid
  end
  
end
