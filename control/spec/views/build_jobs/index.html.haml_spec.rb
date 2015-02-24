require 'rails_helper'

RSpec.describe "build_jobs/index", type: :view do
  before(:each) do
    assign(:build_jobs, [
      BuildJob.create!(
        :banch => nil,
        :base_version => nil,
        :target_platform => nil,
        :notify_user => nil,
        :started_by_user => nil,
        :comment => "Comment",
        :status => 1
      ),
      BuildJob.create!(
        :banch => nil,
        :base_version => nil,
        :target_platform => nil,
        :notify_user => nil,
        :started_by_user => nil,
        :comment => "Comment",
        :status => 1
      )
    ])
  end

  it "renders a list of build_jobs" do
    render
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => "Comment".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
  end
end
