require 'rails_helper'

RSpec.describe "base_versions/edit", type: :view do
  before(:each) do
    @base_version = assign(:base_version, BaseVersion.create!(
      :name => "MyString"
    ))
  end

  it "renders the edit base_version form" do
    render

    assert_select "form[action=?][method=?]", base_version_path(@base_version), "post" do

      assert_select "input#base_version_name[name=?]", "base_version[name]"
    end
  end
end
