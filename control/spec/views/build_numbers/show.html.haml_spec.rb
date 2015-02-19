require 'rails_helper'

RSpec.describe "build_numbers/show", type: :view do
  before(:each) do
    @build_number = assign(:build_number, BuildNumber.create!(
      :branch => "Branch",
      :commit => "Commit",
      :number => "Number"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Branch/)
    expect(rendered).to match(/Commit/)
    expect(rendered).to match(/Number/)
  end
end
