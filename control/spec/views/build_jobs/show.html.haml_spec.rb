require 'rails_helper'

RSpec.describe "build_jobs/show", type: :view do
  before(:each) do
    @build_job = assign(:build_job, BuildJob.create!(
      :banch => nil,
      :base_version => nil,
      :target_platform => nil,
      :notify_user => nil,
      :started_by_user => nil,
      :comment => "Comment",
      :status => 1
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(/Comment/)
    expect(rendered).to match(/1/)
  end
end
