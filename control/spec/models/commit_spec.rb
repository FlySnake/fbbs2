require 'rails_helper'

RSpec.describe Commit, type: :model do
  it "has a valid factory" do
    expect(build(:commit)).to be_valid
  end
  
  it "returns human-readable info" do
    identifier = Faker::Bitcoin.address
    datetime = Time.parse '2015-03-04 07:23:41 UTC'
    message = Faker::Lorem.sentence
    author = Faker::Name.name
    commit = create(:commit, :identifier => identifier, :datetime => datetime, :author => author, :message => message)
    expect(commit.humanize).to eq "#{identifier} | #{author} | #{datetime} | #{message}"
  end
end
