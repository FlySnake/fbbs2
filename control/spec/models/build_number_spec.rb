require 'rails_helper'

RSpec.describe BuildNumber, type: :model do
  it "has a valid factory" do
    expect(build(:build_number)).to be_valid
  end
end
