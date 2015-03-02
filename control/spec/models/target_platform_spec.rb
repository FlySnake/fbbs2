require 'rails_helper'

RSpec.describe TargetPlatform, type: :model do
  it "has a valid factory" do
    expect(build(:target_platform)).to be_valid
  end
end
