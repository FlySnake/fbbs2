require 'rails_helper'

RSpec.describe TestsResult, type: :model do
  it "has a valid factory" do
    expect(build(:tests_result)).to be_valid
  end
end
