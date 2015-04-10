require 'rails_helper'

RSpec.describe TestsBuildJobsRun, type: :model do
  it "has a valid factory" do
    expect(build(:tests_build_jobs_run)).to be_valid
  end
end
