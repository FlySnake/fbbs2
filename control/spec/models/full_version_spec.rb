require 'rails_helper'

RSpec.describe FullVersion, type: :model do
  it "has a valid factory" do
    expect(build(:full_version)).to be_valid
  end
  
end
