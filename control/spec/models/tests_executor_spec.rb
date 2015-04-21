require 'rails_helper'

RSpec.describe TestsExecutor, type: :model do
  it "has a valid factory" do
    expect(build(:tests_executor)).to be_valid
  end
end
