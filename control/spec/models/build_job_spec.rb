require 'rails_helper'

RSpec.describe BuildJob, type: :model do
  it "has a valid factory" do
    expect(build(:build_job)).to be_valid
  end
  
end
