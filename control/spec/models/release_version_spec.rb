require 'rails_helper'

RSpec.describe ReleaseVersion, type: :model do
  it "has a valid factory" do
    expect(build(:release_version)).to be_valid
  end
  
end
