require 'rails_helper'

RSpec.describe "build_jobs/edit", type: :view do
  before(:each) do
    @build_job = assign(:build_job, BuildJob.create!(
      :banch => nil,
      :base_version => nil,
      :target_platform => nil,
      :notify_user => nil,
      :started_by_user => nil,
      :comment => "MyString",
      :status => 1
    ))
  end

  it "renders the edit build_job form" do
    render

    assert_select "form[action=?][method=?]", build_job_path(@build_job), "post" do

      assert_select "input#build_job_banch_id[name=?]", "build_job[banch_id]"

      assert_select "input#build_job_base_version_id[name=?]", "build_job[base_version_id]"

      assert_select "input#build_job_target_platform_id[name=?]", "build_job[target_platform_id]"

      assert_select "input#build_job_notify_user_id[name=?]", "build_job[notify_user_id]"

      assert_select "input#build_job_started_by_user_id[name=?]", "build_job[started_by_user_id]"

      assert_select "input#build_job_comment[name=?]", "build_job[comment]"

      assert_select "input#build_job_status[name=?]", "build_job[status]"
    end
  end
end
