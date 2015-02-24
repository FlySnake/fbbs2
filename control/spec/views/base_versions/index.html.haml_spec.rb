require 'rails_helper'

RSpec.describe "base_versions/index", type: :view do
  before(:each) do
    assign(:base_versions, [
      BaseVersion.create!(
        :name => "Name"
      ),
      BaseVersion.create!(
        :name => "Name"
      )
    ])
  end

  it "renders a list of base_versions" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
  end
end
