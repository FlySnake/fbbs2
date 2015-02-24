require 'rails_helper'

RSpec.describe "base_versions/show", type: :view do
  before(:each) do
    @base_version = assign(:base_version, BaseVersion.create!(
      :name => "Name"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
  end
end
