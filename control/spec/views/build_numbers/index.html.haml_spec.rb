require 'rails_helper'

RSpec.describe "build_numbers/index", type: :view do
  before(:each) do
    assign(:build_numbers, [
      BuildNumber.create!(
        :branch => "Branch",
        :commit => "Commit",
        :number => "Number"
      ),
      BuildNumber.create!(
        :branch => "Branch",
        :commit => "Commit",
        :number => "Number"
      )
    ])
  end

  it "renders a list of build_numbers" do
    render
    assert_select "tr>td", :text => "Branch".to_s, :count => 2
    assert_select "tr>td", :text => "Commit".to_s, :count => 2
    assert_select "tr>td", :text => "Number".to_s, :count => 2
  end
end
