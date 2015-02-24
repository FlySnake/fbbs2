require 'rails_helper'

RSpec.describe "base_versions/new", type: :view do
  before(:each) do
    assign(:base_version, BaseVersion.new(
      :name => "MyString"
    ))
  end

  it "renders new base_version form" do
    render

    assert_select "form[action=?][method=?]", base_versions_path, "post" do

      assert_select "input#base_version_name[name=?]", "base_version[name]"
    end
  end
end
