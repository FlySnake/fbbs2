require 'rails_helper'

RSpec.describe IssueTracker, type: :model do
  it "has a valid factory" do
    expect(build(:issue_tracker)).to be_valid
  end
  
  it "creates full weblink to issue" do
    link = "http://example.com/issues/:issue"
    e = build(:issue_tracker, :weblink => link)
    expect(e.full_weblink("1234567")).to eq link.sub(":issue", "1234567")
  end
  
  it "is invalid with duplicate title" do
    title = Faker::Lorem.word
    create(:issue_tracker, :title => title)
    expect(build(:issue_tracker, :title => title)).to be_invalid
  end
  
end
